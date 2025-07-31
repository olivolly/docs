#!/usr/bin/env bash
# dash_scaffold_mintlify.sh — Git Bash-compatible MDX file generator

set -euo pipefail

# -------- Settings --------
ROOT="."  # Or "content" if preferred
EXT="mdx"

# -------- Helpers --------
write_page () {
  # $1: relative path (without extension), $2: title, $3: sidebarTitle
  local relpath="$1"
  local fullpath="$ROOT/$relpath.$EXT"
  local title="$2"
  local sidebar="$3"

  mkdir -p "$(dirname "$fullpath")"

  if [[ -f "$fullpath" ]]; then
    echo "exists: $fullpath"
  else
    cat > "$fullpath" <<EOF
---
title: $title
sidebarTitle: $sidebar
---

# $title

> TODO: Draft content for "$title".

EOF
    echo "created: $fullpath"
  fi
}

# -------- File List --------
# Format: path|title|sidebarTitle
ENTRIES=$(cat <<'EOF'
getting-started/what-is-dash|What is DASH|What is DASH
getting-started/overview-of-dash-modules|Overview of DASH Modules|Overview of DASH Modules
getting-started/navigating-the-interface|Navigating the Interface|Navigating the Interface
dashboard|Dashboard|Dashboard
accounting/accounting-module-overview|Accounting Module Overview|Accounting
accounting/accounts-payable|Accounts Payable Submodule|Accounts Payable
accounting/accounts-receivable|Accounts Receivable Submodule|Accounts Receivable
accounting/fixed-assets|Fixed Assets Submodule|Fixed Assets
accounting/general-ledger|General Ledger Submodule|General Ledger
accounting/maintenance|Maintenance Submodule|Maintenance
administration/administration-module-overview|Administration Module Overview|Administration
administration/manage-companies|Manage Companies Submodule|Manage Companies
administration/manage-entities|Manage Entities Submodule|Manage Entities
administration/manage-navigation|Manage Navigation Submodule|Manage Navigation
customer-information/customer-information-module-overview|Customer Information Module Overview|Customer Information
customer-information/maintenance|Maintenance Submodule|Maintenance
customer-information/manage-customers|Manage Customers Submodule|Manage Customers
ecommerce/ecommerce-module-overview|eCommerce Module Overview|eCommerce
ecommerce/reports|Reports Submodule|Reports
inventory/inventory-module-overview|Inventory Module Overview|Inventory
inventory/labels|Labels Submodule|Labels
inventory/material-handler|Material Handler Submodule|Material Handler
inventory/reports|Reports Submodule|Reports
miscellaneous/miscellaneous-module-overview|Miscellaneous Module Overview|Miscellaneous
miscellaneous/dymo-tags|Dymo Tags Submodule|Dymo Tags
miscellaneous/it-functions|IT Functions Submodule|IT Functions
miscellaneous/manage-freight-carriers|Manage Freight Carriers Submodule|Manage Freight Carriers
miscellaneous/mass-remove-pallets|Mass Remove Pallets Submodule|Mass Remove Pallets
order-processing/order-processing-module-overview|Order Processing Module Overview|Order Processing
order-processing/loss-of-sales|Loss of Sales Submodule|Loss of Sales
order-processing/manage-orders|Manage Orders Submodule|Manage Orders
order-processing/order-picking|Order Picking Submodule|Order Picking
order-processing/picking-status|Picking Status Submodule|Picking Status
order-processing/qc-orders|QC Orders Submodule|QC Orders
order-processing/reports|Reports Submodule|Reports
part-information/part-information-module-overview|Part Information Module Overview|Part Information
part-information/maintenance|Maintenance Submodule|Maintenance
part-information/manage-formulas|Manage Formulas Submodule|Manage Formulas
part-information/manage-holds|Manage Holds Submodule|Manage Holds
part-information/manage-msds-sheets|Manage MSDS Sheets Submodule|Manage MSDS Sheets
part-information/manage-parts|Manage Parts Submodule|Manage Parts
part-information/manage-product-classes|Manage Product Classes Submodule|Manage Product Classes
part-information/reports|Reports Submodule|Reports
physical-inventory/physical-inventory-module-overview|Physical Inventory Module Overview|Physical Inventory
physical-inventory/inventory-tag-control|Inventory Tag Control Submodule|Inventory Tag Control
physical-inventory/physical-inventory-reports|Physical Inventory Reports Submodule|Physical Inventory Reports
physical-inventory/record-inventory|Record Inventory Submodule|Record Inventory
production-tracking/production-tracking-module-overview|Production Tracking Module Overview|Production Tracking
production-tracking/batch-tickets|Batch Tickets Submodule|Batch Tickets
production-tracking/bottling-jobs|Bottling Jobs Submodule|Bottling Jobs
production-tracking/dashboard|Dashboard Submodule|Dashboard
production-tracking/production-reports|Production Reports Submodule|Production Reports
purchase-orders/purchase-orders-module-overview|Purchase Orders Module Overview|Purchase Orders
purchase-orders/manage-purchase-orders|Manage Purchase Orders Submodule|Manage Purchase Orders
purchase-orders/manage-vendors|Manage Vendors Submodule|Manage Vendors
purchase-orders/receiving|Receiving Submodule|Receiving
purchase-orders/reports|Reports Submodule|Reports
scheduling/scheduling-module-overview|Scheduling Module Overview|Scheduling
scheduling/manage-schedules|Manage Schedules Submodule|Manage Schedules
scheduling/scheduling-reports|Scheduling Reports Submodule|Scheduling Reports
shipping/shipping-module-overview|Shipping Module Overview|Shipping
shipping/advanced-shipping-notices|Advanced Shipping Notices Submodule|Advanced Shipping Notices
shipping/bill-of-lading|Bill of Lading Submodule|Bill of Lading
shipping/kits|Kits Submodule|Kits
shipping/print-shipping-documents|Print Shipping Documents Submodule|Print Shipping Documents
shipping/reports|Reports Submodule|Reports
shipping/selector|Selector Submodule|Selector
shipping/spd|SPD Submodule|SPD
work-orders/work-orders-module-overview|Work Orders Module Overview|Work Orders
work-orders/manage-work-orders|Manage Work Orders Submodule|Manage Work Orders
work-orders/work-order-production|Work Order Production Submodule|Work Order Production
work-orders/work-order-reports|Work Order Reports Submodule|Work Order Reports
EOF
)

# -------- Process Each Entry --------
echo "$ENTRIES" | while IFS='|' read -r path title sidebar; do
  [[ -z "$path" ]] && continue
  write_page "$path" "$title" "$sidebar"
done

echo
echo "✅  All MDX files with correct frontmatter have been created under '$ROOT/'."
