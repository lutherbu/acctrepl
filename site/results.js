import {count, disclosure, element as el, facts, table, words} from "./ui.js";

function notes(title, entries) {
  if (!entries?.length) return null;
  const list = el("ul");
  for (const entry of entries) list.append(el("li", "", entry));
  return disclosure(title, list);
}

function groups(items) {
  return items?.map(item => Array.isArray(item) ? item.join(" × ") : item).join(", ");
}

function samples(data) {
  const panel = el("div", "", facts([["Extraction", words(data.status)]]));
  for (const s of data.samples) {
    const p = s.sample_period || {};
    let period = "Not reported";
    if (p.years?.length) period = p.years.join(", ");
    else if (p.begin != null && p.end != null) period = p.begin === p.end ? String(p.begin) : `${p.begin}–${p.end}`;
    else if (p.begin != null) period = "From " + p.begin;
    else if (p.end != null) period = "Through " + p.end;
    const sources = Object.entries(s.data_sources || {}).map(([group, source]) => [
      words(group), (Array.isArray(source) ? source : Object.keys(source || {})).join(", "),
    ]).filter(([, names]) => names);
    const card = el("article", "result-block", el("h3", "", s.sample_label || s.sample_id),
      facts([["Sample size", count(s.sample_size)], ["Unit", words(s.sample_unit)], ["Period", period]]),
      s.period_detail && el("p", "", s.period_detail));
    if (sources.length) card.append(el("h4", "", "Data sources"), facts(sources));
    if (s.analysis_sizes?.length) {
      card.append(disclosure("Analysis-specific sample sizes", table(["Analysis", "Observations"],
        s.analysis_sizes.map(row => [row.label, count(row.sample_size)]))));
    }
    panel.append(card);
  }
  if (!data.samples.length) panel.append(el("p", "", "This extraction contains no baseline sample."));
  return panel;
}

const cellText = cell => cell?.text ?? cell?.value ?? "—";

function modelDetails(model) {
  const specs = model.specifications || {};
  const dv = model.dependent_variable;
  const body = el("div", "detail-body",
    facts([["Model role", words(model.model_role)], ["Dependent variable", dv?.name],
      ["Estimation method", model.method_reported || model.method || "Not reported"],
      ["Sample size", count(model.sample_size)], ["Fixed effects", groups(specs.fixed_effects?.groups)],
      ["Cluster variables", groups(specs.standard_errors?.cluster_groups)]]),
    dv?.definition && el("p", "", dv.definition),
    model.method_details && el("p", "", model.method_details),
    model.equation_text && el("pre", "equation", model.equation_text));
  const sets = new Map(model.result_sets.map(s => [s.result_set_id, s.label]));
  const rows = [];
  function addResult(term, role, result) {
    const reported = result.reported || {};
    const inference = [];
    if (reported.statistic) inference.push(`${reported.statistic.kind} = ${cellText(reported.statistic.cell)}`);
    if (reported.standard_error) inference.push("SE = " + cellText(reported.standard_error));
    if (reported.p_value) inference.push("p: " + cellText(reported.p_value));
    rows.push([term, role, sets.get(result.result_set_id) || result.result_set_id, words(result.estimate_kind),
      cellText(reported.estimate), inference.join(" · ") || "—"]);
  }
  for (const variable of model.independent_variables) {
    const role = variable.is_research_interest === true ? "Research interest"
      : variable.is_research_interest === false ? "Control" : "Unspecified";
    for (const result of variable.results) {
      const term = result.label && result.label !== variable.name ? `${variable.name} (${result.label})` : variable.name;
      addResult(term, role, result);
    }
  }
  for (const result of [...model.intercept_results, ...model.auxiliary_results]) {
    addResult(result.label, words(result.target_kind), result);
  }
  body.append(el("h4", "", "Reported estimates"));
  body.append(rows.length ? table(["Term", "Role", "Result set", "Measure", "Estimate", "Inference"], rows)
    : el("p", "", model.results_reason || "No estimates are recorded for this model."));
  if (model.independent_variables.length) {
    body.append(disclosure("Variable definitions", facts(model.independent_variables.map(v => [v.name, v.definition]))));
  }
  return body;
}

function models(data) {
  const panel = el("div", "", facts([["Models", count(data.models.length)], ["Reported results", words(data.results_status)]]));
  for (const [i, model] of data.models.entries()) {
    const detail = disclosure(model.model_label || model.model_id);
    detail.addEventListener("toggle", () => {
      if (detail.open && detail.children.length === 1) detail.append(modelDetails(model));
    });
    detail.open = i === 0;
    panel.append(detail);
  }
  if (!data.models.length) panel.append(el("p", "", "This extraction contains no baseline regression."));
  return panel;
}

function reconstructionFeasibility(data, dataLabels) {
  const summary = data.summary;
  const panel = el("div", "", facts([["Paper assessment", words(summary.outcome)], ["Eligibility", words(data.eligibility)], ["Baseline models", count(summary.baseline_models)],
    ["Baseline fits", count(summary.baseline_fits)], ["Ready to attempt", count(summary.attempt_ready_count)]]));
  if (data.assessments.length) panel.append(table(["Model", "Result set", "Data status", "Ready to attempt"],
    data.assessments.map(a => [a.model_id, a.result_set_id, words(dataLabels[a.data_status]), a.attempt_ready ? "Yes" : "No"])));
  const reasons = data.requirements.filter(r => r.blocked_reason || r.unresolved_reason);
  if (reasons.length) panel.append(el("h3", "", "Data requirements"), table(["Requirement", "Status", "Reason"],
    reasons.map(r => [r.description, words(dataLabels[r.data_status]), r.blocked_reason || r.unresolved_reason])));
  const issues = data.assessments.flatMap(a => a.implementation_issues.map(i => i.description));
  panel.append(...[notes("Implementation issues", [...new Set(issues)]), notes("Review notes", data.review_notes)].filter(Boolean));
  return panel;
}

function authorFeasibility(data, dataLabels) {
  const panel = el("div");
  for (const scope of data.scopes) {
    const issues = data.issues.filter(issue => scope.issue_ids.includes(issue.id));
    panel.append(el("article", "result-block", el("h3", "", words(scope.id)), el("p", "", scope.description),
      facts([["Data status", words(dataLabels[scope.data_status])], ["Execution readiness", words(scope.execution_readiness)]]),
      notes("Issues affecting this scope", issues.map(i => i.description))));
  }
  return panel;
}

function reproductions(data) {
  return el("div", "", facts([["Accepted attempt", data.attempt], ["Status", words(data.status)],
    ["Executed scopes", `${count(data.executed_scopes)} of ${count(data.total_scopes)}`]]),
    table(["Model", "Result set", "Execution", "Fidelity", "Recorded limitation"],
      data.fits.map(f => [f.model_id, f.result_set_id, words(f.execution_status), words(f.fidelity), f.blocked_reason || f.execution_detail])),
    notes("Limitations", data.limitations));
}

function executions(data) {
  return el("div", "", facts([["Scope", words(data.scope_id)], ["Outcome", words(data.outcome)],
    ["Execution verified", data.execution_verified ? "Yes" : "No"], ["Comparison with reference", words(data.comparison.status)]]),
    table(["Stage", "Status", "Recorded result"], data.stage_results.map(s => [s.stage_id, words(s.status), s.note])),
    notes("Comparison notes", data.comparison.notes), notes("Gaps", data.gaps.map(g => g.description)));
}

function replications(data) {
  const panel = el("div", "", facts([["Outcome", words(data.outcome)], ["Route", words(data.route)],
    ["Requested extension", `${data.years} years`]]));
  for (const analysis of data.analyses) {
    const card = el("article", "result-block", el("h3", "", analysis.label || analysis.scope_id),
      facts([["Outcome", words(analysis.status)], ["Original end", analysis.original_end],
        ["Requested end", analysis.requested_end], ["Supported end", analysis.supported_end],
        ["Original observations", count(analysis.original_n)], ["Added observations", count(analysis.added_n)],
        ["Count unit", analysis.count_unit]]), el("p", "", analysis.reason));
    if (analysis.comparison) {
      const text = typeof analysis.comparison === "string" ? el("p", "", analysis.comparison)
        : el("pre", "code", JSON.stringify(analysis.comparison, null, 2));
      card.append(disclosure("Original and extended results", text));
    }
    panel.append(card);
  }
  const limitations = notes("Limitations", data.limitations);
  if (limitations) panel.append(limitations);
  return panel;
}

export const summaries = {
  samples, models, feasibility_reproduction: reconstructionFeasibility, reproductions,
  feasibility_execution: authorFeasibility, executions, replications,
};
