// Workflow order matches the homepage. Field names are the paper catalog's public interface.
export const workflows = [
  {id: "samples", field: "sample_path", name: "Paper samples", short: "Samples", skill: "extract-accounting-samples"},
  {id: "models", field: "model_path", name: "Models & reported results", short: "Models", skill: "extract-accounting-models"},
  {id: "feasibility_reproduction", field: "feasibility_reproduction_path", name: "Reconstruction feasibility", short: "Reconstruction feasibility", skill: "check-replication-feasibility"},
  {id: "reproductions", field: "reproduction_path", name: "Reproductions & comparisons", short: "Reproduction", skill: "reproduce-accounting-models"},
  {id: "feasibility_execution", field: "feasibility_execution_path", name: "Author-workflow feasibility", short: "Author-workflow feasibility", skill: "check-execution-feasibility"},
  {id: "executions", field: "execution_path", name: "Author-analysis execution", short: "Author execution", skill: "execute-author-analysis"},
  {id: "replications", field: "replication_path", name: "Extended-sample replications", short: "Extended sample", skill: "replicate-extended-samples"},
];

export function element(tag, className, ...children) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  for (const child of children) {
    if (child !== undefined && child !== null) node.append(child);
  }
  return node;
}

export function link(text, href, className) {
  const node = element("a", className, text);
  node.href = href;
  return node;
}

export function route(values = {}) {
  const params = new URLSearchParams();
  for (const [key, value] of Object.entries(values)) {
    if (value !== "" && value != null) params.set(key, value);
  }
  return "papers.html" + (params.size ? "?" + params : "");
}

export function asset(path) {
  return path.split("/").map(encodeURIComponent).join("/");
}

export async function loadText(path) {
  const response = await fetch(asset(path));
  if (!response.ok) throw new Error(`Could not load ${path} (HTTP ${response.status}).`);
  return response.text();
}

export const words = value => String(value ?? "Not reported").replaceAll("_", " ");
export const count = value => Number.isInteger(value) ? value.toLocaleString("en-US") : "Not reported";

export function facts(pairs) {
  const list = element("dl", "facts");
  for (const [key, value] of pairs) {
    if (value != null && value !== "") {
      list.append(element("div", "", element("dt", "", key), element("dd", "", value)));
    }
  }
  return list;
}

export function table(headers, rows) {
  const heading = element("tr");
  for (const label of headers) {
    const th = element("th", "", label);
    th.scope = "col";
    heading.append(th);
  }
  const body = element("tbody");
  for (const row of rows) {
    body.append(element("tr", "", ...row.map(cell => element("td", "", cell ?? "—"))));
  }
  const scroller = element("div", "table-scroll", element("table", "data-table", element("thead", "", heading), body));
  return scroller;
}

export function disclosure(title, ...children) {
  return element("details", "disclosure", element("summary", "", title), ...children);
}
