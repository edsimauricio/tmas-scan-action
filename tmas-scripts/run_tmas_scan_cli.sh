#!/bin/bash
# Copyright (C) 2025 Trend Micro Inc. All rights reserved.

# exit the script on any error
set -euo pipefail

# Inputs (from env vars or arguments)
TMAS_VULNERABILITY_SCAN="${TMAS_VULNERABILITY_SCAN:-false}"
TMAS_MALWARE_SCAN="${TMAS_MALWARE_SCAN:-false}"
TMAS_SECRETS_SCAN="${TMAS_SECRETS_SCAN:-false}"
TMAS_ARTIFACT="${TMAS_ARTIFACT:-}"
TMAS_ADDITIONAL_ARGS="${TMAS_ADDITIONAL_ARGS:-}"
TMAS_DEFAULT_ARGS="${TMAS_DEFAULT_ARGS:-}"
TMAS_API_KEY="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJjaWQiOiJiNjY5NDU0MS0wM2ZkLTQxNzMtOWEzYS05NWJkODk2ZmUyOWIiLCJjcGlkIjoic3ZwIiwicHBpZCI6ImN1cyIsIml0IjoxNzgwMjg1OTM0LCJldCI6MTc4ODA2MTkzMywiaWQiOiI3MTlkNzg1Ni04OTlmLTRlYjgtYmFlMi05NWVmMTUwZDU5YWMiLCJ0b2tlblVzZSI6ImN1c3RvbWVyIn0.nr8naGdQ052UmRERZt2kuK20jmsE1hjndhpxgwtiXsP1C3lF3B5IzDIKiRPeFDzUZZTn8nF6vfYCbcwOEE3GtsvVdtZZyx5MIZm_zcI3Jr5Rga6CJlOvnTPG3U68_3o2nV-qYuYCmYx4ByX7HMZE67c4TqhI6NLEK-D-rf9ZFZ9yWef6szBoQ5i_FEQzfFk_c9RWNRCHXlymQDtyVcrF0OR8WW01TwaiD4HOGUX1iCtYXGjttbUQFigHHeDr-p87T_O-cd8xzdqWRG1rZnpNaZ-IVcuQ-IsWgA3fOTZHICDZL8JtEGbSvcUe8krGo37W1zZ_Yjfxz6-LDgqvY3ZMCd0KCbG-T8ZsZt_Empp-O8LTJl01Zqc48QyiiXFlMlp0K726jAkwTLN5N_h0vFKRNlRQR1X3AHXUFw71ak9bA6xcVjuZNEH86XVP6GeizokGD18vEoJNQsPZrzjxLnYgwHp_jUHmkJasPNHOv0yMt7YB9t-Xg4wRg9_a3KU01rGivT1sEX7i2jjCCSmcCVmF8pP24w44OHpSuny7p8rUk6cspjR-h-Fj4FCx1mAyR3tshk4WgLdkNPAQrWuhjTpsOcnskF240By06qSmWcPO-5c4RHfCblzx1S7VI-ati_tr-Sjc02CscUQ1EaVHjj4ZqNEfuOdE21hzxmGSJlY5dJ4"
REPORT_FILE="${REPORT_FILE:-tmas_scan_report.json}"

# Build TMAS CLI command
TMAS_CMD="tmas scan"
TMAS_ARGS=()

# Map flags to TMAS CLI arguments
if [ "$TMAS_VULNERABILITY_SCAN" = "true" ]; then
	TMAS_ARGS+=("-V")
fi
if [ "$TMAS_MALWARE_SCAN" = "true" ]; then
	TMAS_ARGS+=("-M")
fi
if [ "$TMAS_SECRETS_SCAN" = "true" ]; then
	TMAS_ARGS+=("-S")
fi
if [ -n "$TMAS_ARTIFACT" ]; then
	TMAS_ARGS+=("$TMAS_ARTIFACT")
fi
if [ -n "$TMAS_ADDITIONAL_ARGS" ]; then
	read -ra ADDITIONAL_ARGS_ARRAY <<<"$TMAS_ADDITIONAL_ARGS"
	TMAS_ARGS+=("${ADDITIONAL_ARGS_ARRAY[@]}")
fi
if [ -n "$TMAS_DEFAULT_ARGS" ]; then
	read -ra DEFAULT_ARGS_ARRAY <<<"$TMAS_DEFAULT_ARGS"
	TMAS_ARGS+=("${DEFAULT_ARGS_ARRAY[@]}")
fi

echo "Executing: $TMAS_CMD ${TMAS_ARGS[*]}"

# disable error handling temporarily to capture output
set +e
TMAS_OUTPUT="$($TMAS_CMD "${TMAS_ARGS[@]}" 2> >(cat >&2))"
TMAS_EXIT_CODE=$?
set -e

echo "$TMAS_OUTPUT" >"$REPORT_FILE"

exit $TMAS_EXIT_CODE
