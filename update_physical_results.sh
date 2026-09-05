#!/bin/bash

set -e

SOURCE_ROOT="$HOME/my_designs/CPU_extmem_branchcmp/runs"
DEST_ROOT="$HOME/my_designs/CPU_RV32I/physical_design"

# Automatically find newest OpenLane run
LATEST_RUN=$(find "$SOURCE_ROOT" \
    -maxdepth 1 \
    -type d \
    -name "RUN_*" \
    | sort | tail -1)

if [ -z "$LATEST_RUN" ]; then
    echo "ERROR: No OpenLane runs found in:"
    echo "$SOURCE_ROOT"
    exit 1
fi

RUN_NAME=$(basename "$LATEST_RUN")

echo "======================================"
echo " Updating physical design results"
echo "======================================"
echo "Source run: $RUN_NAME"
echo

# Start with a clean published-results folder
rm -rf "$DEST_ROOT"

mkdir -p "$DEST_ROOT/gds"
mkdir -p "$DEST_ROOT/reports"

# --------------------------------------------------
# Run information
# --------------------------------------------------

echo "Source OpenLane run: $RUN_NAME" > "$DEST_ROOT/RUN_INFO.txt"

# --------------------------------------------------
# Final GDSII
# --------------------------------------------------

copy_file () {
    SOURCE="$1"
    DEST="$2"
    DESCRIPTION="$3"

    if [ -f "$SOURCE" ]; then
        cp "$SOURCE" "$DEST"
        echo "[OK] $DESCRIPTION"
    else
        echo "[MISSING] $DESCRIPTION"
        echo "          $SOURCE"
    fi
}

copy_file \
    "$LATEST_RUN/56-magic-streamout/CPU.gds" \
    "$DEST_ROOT/gds/CPU.gds" \
    "Final GDSII"

# --------------------------------------------------
# Post-PnR Static Timing Analysis
# --------------------------------------------------

copy_file \
    "$LATEST_RUN/54-openroad-stapostpnr/summary.rpt" \
    "$DEST_ROOT/reports/sta_postpnr_summary.rpt" \
    "Post-PnR STA summary"

# --------------------------------------------------
# DRC
# --------------------------------------------------

copy_file \
    "$LATEST_RUN/62-magic-drc/reports/drc_violations.magic.rpt" \
    "$DEST_ROOT/reports/drc_violations.rpt" \
    "Magic DRC report"

# --------------------------------------------------
# Antenna
# --------------------------------------------------

copy_file \
    "$LATEST_RUN/45-openroad-checkantennas-1/reports/antenna_summary.rpt" \
    "$DEST_ROOT/reports/antenna_summary.rpt" \
    "Antenna summary"

# --------------------------------------------------
# Manufacturability
# --------------------------------------------------

copy_file \
    "$LATEST_RUN/74-misc-reportmanufacturability/manufacturability.rpt" \
    "$DEST_ROOT/reports/manufacturability.rpt" \
    "Manufacturability report"

# --------------------------------------------------
# Synthesis statistics
# --------------------------------------------------

copy_file \
    "$LATEST_RUN/06-yosys-synthesis/reports/stat.json" \
    "$DEST_ROOT/reports/synthesis_stats.json" \
    "Yosys synthesis statistics"

# --------------------------------------------------
# Clock Tree Synthesis
# --------------------------------------------------

copy_file \
    "$LATEST_RUN/34-openroad-cts/cts.rpt" \
    "$DEST_ROOT/reports/cts.rpt" \
    "Clock tree synthesis report"

echo
echo "======================================"
echo " Results updated successfully"
echo "======================================"
echo
echo "Published files:"
find "$DEST_ROOT" -type f | sort