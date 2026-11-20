import {asset, count, element as el, facts, link, loadText, route, workflows} from "./ui.js";
import {fileActions, fileTree, jsonTree, previewFile} from "./files.js";
import {summaries} from "./results.js";
import {showCohortProgress} from "./progress.js";

const main = document.querySelector("#content");
const site = new URL("./", document.baseURI);
const pageSize = 25;
const formFields = ["q", "journal", "year", "workflow"];
let inventoryPromise;
const inventory = () => inventoryPromise ??= loadText("site/files.json").then(JSON.parse);
const workflowById = id => workflows.find(w => w.id === id);
const available = row => workflows.filter(w => row[w.field]);
const reference = w => `skills/${w.skill}/SKILL.md`;
const normalized = text => String(text ?? "").normalize("NFKD").replace(/\p{M}/gu, "").toLowerCase();
const archiveName = unit => unit.package_path?.split("/").at(-1) || unit.package_id;

function filtersFrom(params) {
  return Object.fromEntries([...formFields, "page"].map(k => [k, params.get(k) || ""]));
}

function matching(rows, filters) {
  const terms = normalized(filters.q).trim().split(/\s+/).filter(Boolean);
  const workflow = workflowById(filters.workflow);
  return rows.filter(p => (!filters.journal || filters.journal === p.journal)
    && (!filters.year || filters.year === String(p.publication_year))
    && (!filters.workflow || (workflow && p[workflow.field]))
    && terms.every(term => p.searchText.includes(term)));
}

function field(label, control, extraClass = "") {
  control.id = "filter-" + control.name;
  const caption = el("label", "", label);
  caption.htmlFor = control.id;
  return el("div", "field " + extraClass, caption, control);
}

function select(label, name, pairs, all) {
  const control = el("select");
  control.name = name;
  control.add(new Option(all, ""));
  for (const [value, text] of pairs) control.add(new Option(text, value));
  return field(label, control);
}

function pager(links, label) {
  const nav = el("nav", "pager", ...links);
  nav.setAttribute("aria-label", label);
  return nav;
}

function catalog(rows) {
  const search = el("input");
  search.name = "q";
  search.type = "search";
  search.placeholder = "Title, author, DOI, or paper ID";
  const journals = [...new Set(rows.map(r => r.journal))].sort();
  const years = [...new Set(rows.map(r => r.publication_year))].sort((a, b) => b - a);
  const form = el("form", "filters",
    field("Search papers", search, "search"),
    select("Journal", "journal", journals.map(j => [j, j]), "All journals"),
    select("Year", "year", years.map(y => [y, y]), "All years"),
    select("Workflow", "workflow", workflows.map(w => [w.id, w.name]), "All workflows"));
  form.setAttribute("role", "search");
  const countLine = el("h3", "list-count");
  countLine.setAttribute("aria-live", "polite");
  const results = el("div");
  main.replaceChildren(form, el("div", "list-heading", countLine, link("Clear filters", route(), "reset-link")), results);

  function render() {
    const filters = filtersFrom(new URLSearchParams(location.search));
    for (const name of formFields) form.elements[name].value = filters[name];
    const matches = matching(rows, filters);
    const pages = Math.max(1, Math.ceil(matches.length / pageSize));
    const page = Math.min(pages, Math.max(1, Math.trunc(Number(filters.page)) || 1));
    const offset = (page - 1) * pageSize;
    countLine.textContent = `${count(matches.length)} ${matches.length === 1 ? "paper" : "papers"}`;
    main.querySelector(".reset-link").hidden = !formFields.some(k => filters[k]);
    results.replaceChildren();
    if (!matches.length) {
      results.append(el("p", "empty", "No papers match these filters."));
      return;
    }
    const head = el("tr");
    for (const header of ["Paper", "Journal", "Year", "Available outputs"]) {
      const th = el("th", "", header);
      th.scope = "col";
      head.append(th);
    }
    const body = el("tbody");
    for (const row of matches.slice(offset, offset + pageSize)) {
      const values = {...filters, page: page > 1 ? page : "", paper: row.paper_id};
      const tabs = el("div", "output-links");
      for (const w of available(row)) tabs.append(link(w.short, route({...values, view: w.id})));
      const title = link(row.title, route(values), "paper-title");
      const unit = row.sharedDoi ? el("div", "variant", (row.jar_packages || []).map(archiveName).join(", ") || row.paper_id) : null;
      body.append(el("tr", "", el("td", "paper-cell", title, el("div", "byline", row.authors), unit),
        el("td", "journal-cell", row.journal), el("td", "year-cell", row.publication_year),
        el("td", "output-cell", tabs)));
    }
    results.append(el("table", "catalog-table", el("thead", "", head), body));
    if (pages > 1) {
      const change = (label, n) => link(label, route({...filters, page: n > 1 ? n : ""}));
      results.append(pager([page > 1 ? change("← Previous page", page - 1) : null,
        el("span", "", `Page ${page} of ${pages}`), page < pages ? change("Next page →", page + 1) : null], "Catalog pages"));
    }
  }
  function applyFilters(push) {
    const values = Object.fromEntries(new FormData(form));
    const url = route(values);
    if (new URL(url, site).href !== location.href) {
      history[push ? "pushState" : "replaceState"](null, "", url);
    }
    render();
  }
  search.addEventListener("input", () => applyFilters(false));
  form.addEventListener("change", event => { if (event.target !== search) applyFilters(true); });
  form.addEventListener("submit", event => { event.preventDefault(); applyFilters(false); });
  window.addEventListener("popstate", render);
  render();
}

function paperNavigation(rows, row, filters, view) {
  const matches = matching(rows, filters);
  const papers = view ? matches.filter(p => p[view.field]) : matches;
  const index = papers.indexOf(row);
  const pageOf = i => Math.floor(i / pageSize) + 1;
  const listIndex = matches.indexOf(row);
  const currentPage = listIndex >= 0 ? pageOf(listIndex) : Number(filters.page) || 1;
  const controls = [link("← Paper catalog", route({...filters, page: currentPage > 1 ? currentPage : ""}))];
  if (index >= 0) {
    for (const [label, i] of [["Previous paper", index - 1], ["Next paper →", index + 1]]) {
      const next = papers[i];
      if (next) {
        const page = pageOf(matches.indexOf(next));
        controls.push(link(label, route({...filters, page: page > 1 ? page : "", paper: next.paper_id, view: view?.id})));
      }
    }
  }
  return pager(controls, "Papers in this list");
}

function tabs(row, values, view) {
  const nav = el("nav", "tabs");
  nav.setAttribute("aria-label", "Outputs for this paper");
  const all = [[null, "Overview"], ...available(row).map(w => [w.id, w.short])];
  for (const [id, label] of all) {
    const a = link(label, route({...values, view: id}));
    if (id === (view?.id ?? null)) a.setAttribute("aria-current", "page");
    nav.append(a);
  }
  return nav;
}

// Resolve Markdown against its original file. Only published files receive local links.
function resolveReference(href, sourcePath, files, currentPackage) {
  if (href.startsWith("#")) return href;
  // The README links to the hosted catalog for people reading it on GitHub.
  if (href === "https://lutherbu.github.io/acctrepl/#papers") return route();
  let url;
  try {
    url = new URL(href, new URL(asset(sourcePath), site));
  } catch { return null; }
  if (!["https:", "http:"].includes(url.protocol)) return null;
  if (url.origin !== site.origin) return /^(?:https?:)?\/\//i.test(href) ? url.href : null;
  if (!url.pathname.startsWith(site.pathname)) return null;
  let path;
  try { path = decodeURIComponent(url.pathname.slice(site.pathname.length)); } catch { return null; }
  if (files.documents.includes(path)) return route({doc: path}) + url.hash;
  if (currentPackage && path.startsWith(currentPackage.root + "/")) {
    const relative = path.slice(currentPackage.root.length + 1);
    if (currentPackage.files.includes(relative)) return currentPackage.href(relative) + url.hash;
  }
  const workflow = workflows.find(w => [`output/${w.id}/packages/`, `output/${w.id}/records/`].includes(path));
  if (workflow) return route({workflow: workflow.id});
  if (["docs/papers.csv", "docs/papers.jsonl", "utils/review.html", "utils/filter.html", "index.html"].includes(path)) {
    return asset(path) + url.search + url.hash;
  }
  return null;
}

function showHash() {
  let id;
  try { id = decodeURIComponent(location.hash.slice(1)); } catch { return; }
  if (id) main.querySelector("#" + CSS.escape(id))?.scrollIntoView();
}

async function documentation(path) {
  const files = await inventory();
  if (!files.documents.includes(path)) throw new Error("This document is outside the published guide.");
  const nav = el("nav", "doc-menu", el("h2", "", "Documentation"));
  nav.setAttribute("aria-label", "Guides");
  for (const [file, label] of [["README.md", "Project README"], ...workflows.map(w => [reference(w), w.name])]) {
    const a = link(label, route({doc: file}));
    if (file === path) a.setAttribute("aria-current", "page");
    nav.append(a);
  }
  const article = el("article", "reading", await previewFile(path, href => resolveReference(href, path, files)));
  if (!article.querySelector("h1")) article.prepend(el("h1", "", path.split("/").at(-1)));
  article.append(fileActions(path));
  const sections = [...article.querySelectorAll("h2[id], h3[id]")];
  if (sections.length) {
    nav.append(el("h3", "", "On this page"));
    for (const h of sections) nav.append(link(h.textContent, "#" + encodeURIComponent(h.id), h.tagName === "H3" ? "subheading" : ""));
  }
  document.title = article.querySelector("h1").textContent + " · Accounting Paper Replications";
  main.replaceChildren(el("div", "doc-layout", nav, article));
  showHash();
}

function overview(row) {
  const panel = el("section", "reading", el("h2", "", "Paper overview"),
    facts([["Journal", row.journal_name || row.journal], ["Publication year", row.publication_year],
      ["OpenAlex citations", row.cited_by_count != null ? count(row.cited_by_count) : null],
      ["Field-weighted citation impact", row.fwci], ["Journal citation rank", row.rank_in_journal]]));
  for (const unit of row.jar_packages || []) {
    panel.append(el("h3", "", "Author package"), facts([["Package ID", unit.package_id], ["Archive", archiveName(unit)]]));
    for (const note of unit.identity_notes || []) panel.append(el("p", "", note));
  }
  return panel;
}

async function output(row, workflow, values, requestedFile) {
  const primary = row[workflow.field];
  if (!primary) throw new Error("This workflow has no published output for this paper.");
  const parts = primary.split("/");
  if (parts[0] !== "output" || parts[1] !== workflow.id || parts.some(p => !p || p === ".." || p === "." || p.includes("\\"))) {
    throw new Error("The catalog contains an invalid publication path.");
  }
  const article = el("article", "reading", el("h2", "", workflow.name));
  let tree = null, selected = primary;
  if (parts[2] === "packages") {
    const root = parts.slice(0, 4).join("/");
    const files = await inventory();
    const entries = files.packages[root];
    const primaryFile = parts.slice(4).join("/");
    const file = requestedFile || primaryFile;
    if (!entries?.includes(file) || !entries.includes(primaryFile)) throw new Error("This file is outside the published package.");
    const href = f => route({...values, view: workflow.id, file: f === primaryFile ? null : f});
    tree = fileTree(entries, file, href);
    selected = root + "/" + file;
    if (file !== primaryFile) {
      article.replaceChildren(link("← " + workflow.name, href(primaryFile), "inline-link"),
        el("h2", "filename", file), fileActions(selected),
        await previewFile(selected, h => resolveReference(h, selected, files, {root, files: entries, href})));
    }
  } else if (parts[2] !== "records" || parts.length !== 4 || requestedFile) {
    throw new Error("This record has no package files.");
  }
  if (selected === primary) {
    const data = JSON.parse(await loadText(primary));
    let dataLabels;
    if (workflow.id.startsWith("feasibility_")) {
      const schema = JSON.parse(await loadText("skills/check-replication-feasibility/references/feasibility_classification.schema.json"));
      const approach = workflow.id === "feasibility_execution" ? "author_package" : "independent_reconstruction";
      dataLabels = schema.x_status_mappings[approach];
    }
    article.append(summaries[workflow.id](data, dataLabels), fileActions(primary), jsonTree("Full JSON", data));
  }
  return tree ? el("div", "package-layout", tree, article) : article;
}

async function paper(rows, params) {
  const row = rows.find(r => r.paper_id === params.get("paper"));
  if (!row) throw new Error("This paper ID is outside the catalog.");
  const filters = filtersFrom(params);
  const values = {...filters, paper: row.paper_id};
  const view = workflowById(params.get("view"));
  const heading = el("div", "paper-head", el("p", "metadata", row.journal, " · ", row.publication_year),
    el("h1", "", row.title), el("p", "authors", row.authors), el("div", "identifiers", el("code", "", row.paper_id),
      row.doi && link(row.doi, "https://doi.org/" + asset(row.doi))));
  document.title = (view ? view.short + " · " : "") + row.title;
  main.replaceChildren(paperNavigation(rows, row, filters, view), heading, tabs(row, values, view));
  const content = el("div", "result-content");
  main.append(content);
  try {
    if (params.has("view") && !view) throw new Error("Unknown workflow.");
    if (params.has("file") && !view) throw new Error("Select a package to open a file.");
    content.append(el("p", "muted", "Loading…"));
    content.replaceChildren(view ? await output(row, view, values, params.get("file")) : overview(row));
    showHash();
  } catch (error) {
    content.replaceChildren(errorMessage(error));
  }
}

function errorMessage(error) {
  const section = el("section", "reading", el("h2", "", "Unable to open this view"),
    el("p", "", error.message), link("Return to the paper catalog", route()));
  section.setAttribute("role", "alert");
  return section;
}

async function start() {
  const params = new URLSearchParams(location.search);
  const section = document.getElementById("papers");
  if (params.has("paper") || params.has("doc")) {
    document.getElementById("top").classList.add("reader-view");
    section.removeAttribute("aria-labelledby");
    for (const a of document.querySelectorAll('.topbar a[href^="#"], .footer a[href^="#"]')) {
      a.href = "index.html" + a.hash;
    }
  }
  document.querySelector("footer a[rel=license]").href = route({doc: "LICENSE"});
  const loading = el("p", "muted", "Loading…");
  loading.setAttribute("role", "status");
  main.replaceChildren(loading);
  if (params.has("doc")) return documentation(params.get("doc"));
  const chartsReady = params.has("paper") ? null : showCohortProgress();
  const text = await loadText("docs/papers.jsonl");
  const rows = text.split("\n").filter(line => line.trim()).map(line => JSON.parse(line));
  const doiCounts = new Map();
  for (const row of rows) doiCounts.set(row.doi, (doiCounts.get(row.doi) || 0) + 1);
  for (const r of rows) {
    r.sharedDoi = r.doi && doiCounts.get(r.doi) > 1;
    r.searchText = normalized([r.title, r.authors, r.doi, r.doi_url, r.paper_id, ...(r.jar_packages || []).map(p => p.package_id)].join(" "));
  }
  if (params.has("paper")) return paper(rows, params);
  catalog(rows);
  await chartsReady;
  // The browser can reach the fragment before the list gives the page its full height.
  const requestedCatalog = location.hash === "#papers" ||
    (!location.hash && [...formFields, "page"].some(key => params.has(key)));
  if (requestedCatalog && performance.getEntriesByType("navigation")[0]?.type !== "back_forward") {
    requestAnimationFrame(() => section.scrollIntoView({behavior: "instant"}));
  }
}

start().catch(error => main.replaceChildren(errorMessage(error)));
