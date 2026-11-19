import {asset, disclosure, element as el, link, loadText, table} from "./ui.js";

// Build children when a branch opens. A model record can contain several MB of evidence.
export function jsonTree(label, value) {
  if (value === null || typeof value !== "object") {
    return el("div", "json-leaf", el("strong", "", label), el("span", "", value === null ? "null" : String(value)));
  }
  const tree = disclosure(label);
  tree.classList.add("json-tree");
  tree.addEventListener("toggle", () => {
    if (!tree.open || tree.children.length > 1) return;
    const entries = Object.entries(value);
    const group = el("div", "json-group");
    const more = el("button", "small-button", "Show more entries");
    more.type = "button";
    let index = 0;
    function appendNext() {
      more.remove();
      for (const [key, child] of entries.slice(index, index + 100)) group.append(jsonTree(key, child));
      index += 100;
      if (index < entries.length) group.append(more);
    }
    more.addEventListener("click", appendNext);
    if (!entries.length) group.append(Array.isArray(value) ? "[]" : "{}");
    appendNext();
    tree.append(group);
  });
  return tree;
}

export function fileActions(path) {
  const download = link("Download file", asset(path), "inline-link");
  download.download = path.split("/").at(-1);
  return el("div", "file-actions", el("code", "", path.split("/").at(-1)), download);
}

// Route document links before inserting the rendered nodes into the page.
// Authors' HTML is escaped, and remote images never load when opening a document.
export async function markdown(source, resolveLink) {
  const {default: markdownit} = await import("./vendor/markdown-it.mjs");
  const parser = markdownit({html: false, linkify: false});
  parser.renderer.rules.image = (tokens, index) => parser.utils.escapeHtml(tokens[index].content);
  const template = document.createElement("template");
  template.innerHTML = parser.render(source.replace(/^---\r?\n[\s\S]*?\r?\n---(?:\r?\n|$)/, ""));
  for (const a of template.content.querySelectorAll("a")) {
    const href = resolveLink(a.getAttribute("href"));
    if (href) a.href = href;
    else a.replaceWith(...a.childNodes);
  }
  const ids = new Set();
  for (const heading of template.content.querySelectorAll("h1,h2,h3,h4,h5,h6")) {
    const slug = heading.textContent.toLowerCase().trim().replace(/[^\p{L}\p{N}\s_-]/gu, "").replace(/\s+/g, "-");
    let id = slug || "section";
    for (let suffix = 1; ids.has(id); suffix++) id = slug + "-" + suffix;
    heading.id = id;
    ids.add(id);
  }
  for (const item of template.content.querySelectorAll("table")) {
    const wrap = el("div", "table-scroll");
    item.replaceWith(wrap);
    wrap.append(item);
  }
  return el("div", "prose", template.content);
}

function delimitedPreview(text, delimiter) {
  const rows = [];
  let row = [], field = "", quoted = false;
  text = text.replace(/^\uFEFF/, "");
  for (let i = 0; i < text.length && rows.length < 102; i++) {
    const char = text[i];
    if (char === '"' && (quoted || !field)) {
      if (quoted && text[i + 1] === '"') {
        field += '"';
        i++;
      } else {
        quoted = !quoted;
      }
    } else if (!quoted && char === delimiter) {
      row.push(field);
      field = "";
    } else if (!quoted && (char === "\n" || char === "\r")) {
      if (char === "\r" && text[i + 1] === "\n") i++;
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else {
      field += char;
    }
  }
  if (row.length || field) rows.push([...row, field]);
  if (!rows.length) return el("p", "", "This file is empty.");
  return el("div", "", table(rows[0], rows.slice(1, 101)),
    rows.length > 101 ? el("p", "muted", "Showing the first 100 data rows. The download contains the full table.") : null);
}

const textFormats = new Set(["do", "ado", "m", "r", "sas", "py", "sh", "txt", "log", "lst", "tex", "yml", "yaml"]);

export async function previewFile(path, resolveLink) {
  if (path === "LICENSE") {
    const [title, ...paragraphs] = (await loadText(path)).trim().split(/\r?\n\s*\r?\n/);
    return el("div", "prose", el("h1", "", title), ...paragraphs.map(p => el("p", "", p)));
  }
  const extension = path.split(".").at(-1).toLowerCase();
  if (extension === "png") {
    const img = el("img", "figure");
    img.alt = path.split("/").at(-1);
    img.src = asset(path);
    return img;
  }
  if (extension === "pdf") {
    const open = link("Open PDF in a new tab ↗", asset(path), "inline-link");
    open.target = "_blank";
    open.rel = "noopener";
    return open;
  }
  if (!textFormats.has(extension) && !["md", "json", "ipynb", "csv", "tsv"].includes(extension)) {
    return el("p", "", "Download this file to open it in its native application.");
  }
  const text = await loadText(path);
  if (extension === "md") return markdown(text, resolveLink);
  if (extension === "json") {
    const tree = jsonTree("JSON contents", JSON.parse(text));
    tree.open = true;
    return tree;
  }
  if (extension === "csv" || extension === "tsv") return delimitedPreview(text, extension === "csv" ? "," : "\t");
  if (extension === "ipynb") {
    const notebook = el("div", "notebook");
    for (const [i, cell] of JSON.parse(text).cells.entries()) {
      const source = Array.isArray(cell.source) ? cell.source.join("") : cell.source || "";
      notebook.append(el("h4", "", `Cell ${i + 1} · ${cell.cell_type}`),
        cell.cell_type === "markdown" ? await markdown(source, resolveLink) : el("pre", "code", source));
    }
    return notebook;
  }
  const limit = 100000;
  return el("div", "", el("pre", "code", text.slice(0, limit)),
    text.length > limit ? el("p", "muted", "This preview is shortened. The download contains the full text.") : null);
}

export function fileTree(files, selected, fileLink) {
  const root = new Map();
  for (const file of files) {
    const parts = file.split("/");
    let folder = root;
    for (const name of parts.slice(0, -1)) {
      if (!folder.has(name)) folder.set(name, new Map());
      folder = folder.get(name);
    }
    folder.set(parts.at(-1), file);
  }
  function listing(folder, prefix) {
    const list = el("ul");
    for (const [name, child] of folder) {
      if (child instanceof Map) {
        const path = prefix + name + "/";
        const group = el("details", "", el("summary", "", name), listing(child, path));
        group.open = selected.startsWith(path);
        list.append(el("li", "", group));
      } else {
        const a = link(name, fileLink(child));
        if (selected === child) a.setAttribute("aria-current", "page");
        list.append(el("li", "", a));
      }
    }
    return list;
  }
  const menu = el("details", "package-files", el("summary", "", "Package files"), listing(root, ""));
  const desktop = window.matchMedia("(min-width: 681px)");
  menu.open = desktop.matches;
  desktop.addEventListener("change", event => { menu.open = event.matches; });
  return el("aside", "file-tree", menu);
}
