#!/usr/bin/env bash
# dash_scaffold_minimal.sh — create folders & .md pages per the DASH sidebar spec
set -euo pipefail

# -------- Settings --------
ROOT="."   # change to "content" if you prefer
EXT="md"      # change to "mdx" if you prefer

# -------- Helpers --------
slugify () {
  # to-kebab-case for folder names
  # 1) lowercase 2) replace & with ' and ' 3) non-alnum -> - 4) collapse dashes 5) trim dashes
  local s="$1"
  s="${s//&/ and }"
  s="$(echo "$s" | tr '[:upper:]' '[:lower:]')"
  echo "$s" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g'
}

write_page () {
  # $1: filepath (incl. spaces), $2: title (H1)
  local filepath="$1"
  local title="$2"
  mkdir -p "$(dirname "$filepath")"
  if [[ -f "$filepath" ]]; then
    echo "exists: $filepath"
  else
    printf '# %s\n\n> TODO: Draft content for "%s".\n' "$title" "$title" > "$filepath"
    echo "created: $filepath"
  fi
}

mk_overview () {
  # $1: major display name
  local major="$1"
  local major_slug; major_slug="$(slugify "$major")"
  local file="$ROOT/$major_slug/${major} Module Overview.${EXT}"
  write_page "$file" "${major} Module Overview"
}

mk_submodules () {
  # $1: major display name, $2: semicolon-separated minors
  local major="$1"; local minors="$2"
  local major_slug; major_slug="$(slugify "$major")"
  IFS=';' read -r -a items <<< "$minors"
  for item in "${items[@]}"; do
    [[ -z "${item// }" ]] && continue
    local file="$ROOT/$major_slug/${item} Submodule.${EXT}"
    write_page "$file" "${item} Submodule"
  done
}

# -------- Ensure root --------
mkdir -p "$ROOT"

# -------- Getting Started (special) --------
gs_slug="$(slugify "Getting Started")"
write_page "$ROOT/$gs_slug/What is DASH.${EXT}" "What is DASH?"
write_page "$ROOT/$gs_slug/Overview of DASH Modules.${EXT}" "Overview of DASH Modules"
write_page "$ROOT/$gs_slug/Navigating the Interface.${EXT}" "Navigating the Interface"

# -------- Dashboard (special: single top-level page) --------
write_page "$ROOT/Dashboard.${EXT}" "Dashboard"

# -------- Major + Minor spec --------
# Format: Major|Minor1;Minor2;...
SPEC=$(cat <<'EOF'
Accounting|Accounts Payable;Accounts Receivable;Fixed Assets;General Ledger;Maintenance
Administration|Manage Companies;Manage Entities;Manage Navigation
Customer Information|Maintenance;Manage Customers
eCommerce|Reports
Inventory|Labels;Material Handler;Reports
Miscellaneous|Dymo Tags;IT Functions;Manage Freight Carriers;Mass Remove Pallets
Order Processing|Loss of Sales;Manage Orders;Order Picking;Picking Status;QC Orders;Reports
Part Information|Maintenance;Manage Formulas;Manage Holds;Manage MSDS Sheets;Manage Parts;Manage Product Classes;Reports
Physical Inventory|Inventory Tag Control;Physical Inventory Reports;Record Inventory
Production Tracking|Batch Tickets;Bottling Jobs;Dashboard;Production Reports
Purchase Orders|Manage Purchase Orders;Manage Vendors;Receiving;Reports
Scheduling|Manage Schedules;Scheduling Reports
Shipping|Advanced Shipping Notices;Bill of Lading;Kits;Print Shipping Documents;Reports;Selector;SPD
Work Orders|Manage Work Orders;Work Order Production;Work Order Reports
EOF
)

# -------- Generate --------
while IFS='|' read -r major minors; do
  [[ -z "${major// }" ]] && continue
  # create the folder for the major
  mkdir -p "$ROOT/$(slugify "$major")"
  # create the overview for all majors except the two specials
  if [[ "$major" != "Getting Started" && "$major" != "Dashboard" ]]; then
    mk_overview "$major"
  fi
  # create submodules
  if [[ -n "${minors:-}" ]]; then
    mk_submodules "$major" "$minors"
  fi
done <<< "$SPEC"

echo
echo "✅  All folders and page files have been created under '$ROOT/'."