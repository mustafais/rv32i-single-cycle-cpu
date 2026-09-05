#!/bin/bash

set -e

SOURCE_ROOT="$HOME/my_designs/CPU_extmem_branchcmp/runs"
DEST_ROOT="$HOME/my_designs/CPU_RV32I/physical_design"

LATEST_RUN=$(find "$SOURCE_ROOT" -maxdepth 1 -type d -name "RUN_*" | sort | tail -1)

if [ -z "$LATEST_RUN" ]; then
    echo "No OpenLane runs found in $SOURCE_ROOT"
    exit 1
fi

echo "Using OpenLane run:"
echo "$LATEST_RUN"

rm -rf "$DEST_ROOT"
mkdir -p "$DEST_ROOT/gds"
mkdir -p "$DEST_ROOT/reports"

echo "Copying GDS..."

find "$LATEST_RUN" \
    -type f \
    -name "*.gds" \
    -exec cp -v {} "$DEST_ROOT/gds/" \;

echo "Copying metrics..."

find "$LATEST_RUN" \
    -type f \
    \( -name "metrics.csv" -o -name "metrics.json" \) \
    -exec cp -v {} "$DEST_ROOT/reports/" \;

echo "Copying summary reports..."

find "$LATEST_RUN" \
    -type f \
    \( \
        -iname "*sta*postpnr*" \
        -o -iname "*timing*summary*" \
        -o -iname "*drc*summary*" \
        -o -iname "*antenna*summary*" \
    \) \
    -exec cp -v {} "$DEST_ROOT/reports/" \;

echo
echo "Done."
echo "Results copied to:"
echo "$DEST_ROOT"
