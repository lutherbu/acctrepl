import {count, element as el, loadText} from "./ui.js";

const labels = {
  local_available: "Available locally",
  public_acquisition_required: "Public acquisition required",
  access_blocked: "Access blocked",
  undetermined: "Undetermined",
  no_observed_data_required: "No observed data required",
  unclassified: "Outside classification",
};
const titles = {cited: "Citation-selected papers", jar: "JAR author packages"};
const percent = new Intl.NumberFormat("en-US", {style: "percent", maximumFractionDigits: 1});

function cohortChart(id, data) {
  const title = titles[id];
  const executed = Object.values(data.classes).reduce((n, row) => n + row.executed, 0);
  const rate = data.total ? " · " + percent.format(executed / data.total) : "";
  const caption = el("figcaption", "", el("h4", "", title),
    el("p", "cohort-total", el("strong", "", count(executed)), " of ", count(data.total), " executed", rate));
  const track = el("div", "cohort-track");
  track.setAttribute("aria-hidden", "true");
  const head = el("tr");
  for (const text of ["Data availability", "Executed", "Unexecuted"]) {
    const th = el("th", "", text);
    th.scope = "col";
    head.append(th);
  }
  const body = el("tbody");
  for (const [key, label] of Object.entries(labels)) {
    const counts = data.classes[key];
    if (key === "unclassified" && !counts.executed && !counts.unexecuted) continue;
    const name = el("th", "", el("span", "cohort-swatch"), label);
    name.scope = "row";
    if (key === "unclassified") {
      const {unassessed, no_baseline} = data.unclassified_reasons;
      const reasons = [unassessed && count(unassessed) + " unassessed",
        no_baseline && count(no_baseline) + " without an eligible baseline"].filter(Boolean);
      name.append(el("small", "", reasons.join(" · ")));
    }
    const row = el("tr", "", name);
    row.dataset.category = key;
    for (const state of ["executed", "unexecuted"]) {
      const n = counts[state];
      row.append(el("td", "", count(n)));
      if (n === 0) continue;
      const segment = el("span", state === "unexecuted" ? "striped" : "");
      Object.assign(segment.dataset, {category: key, state, count: n});
      segment.style.flexGrow = n;
      segment.title = `${label} · ${state} · ${count(n)} (${percent.format(n / data.total)})`;
      track.append(segment);
    }
    body.append(row);
  }
  const table = el("table", "cohort-table", el("thead", "", head), body);
  table.setAttribute("aria-label", title + " by data availability and execution");
  const note = id === "cited"
    ? "Execution counts come from the independent reconstruction runs."
    : "Each package uses the scope actually run. Unexecuted packages use the analysis-only assessment when available, otherwise the full workflow.";
  const figure = el("figure", "cohort-chart", caption, track, table, el("p", "cohort-note", note));
  figure.dataset.cohort = id;
  return figure;
}

export async function showCohortProgress() {
  const container = document.getElementById("cohort-charts");
  try {
    const stats = JSON.parse(await loadText("site/progress.json"));
    container.replaceChildren(...Object.keys(titles).map(id => cohortChart(id, stats[id])));
    const updated = document.getElementById("progress-updated");
    const date = new Date(stats.updated_at);
    if (stats.updated_at && Number.isFinite(date.getTime())) {
      updated.dateTime = stats.updated_at;
      const format = new Intl.DateTimeFormat("en-GB", {day: "numeric", month: "short", year: "numeric",
        hour: "2-digit", minute: "2-digit", timeZone: "UTC", timeZoneName: "short"});
      updated.textContent = "Last updated " + format.format(date);
      updated.hidden = false;
    }
  } catch {
    container.replaceChildren(el("p", "muted", "The cohort counts could not be loaded."));
  }
}
