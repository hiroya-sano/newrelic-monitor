#!/bin/bash

# ====== 環境変数チェック ======
if [[ -z "$TF_VAR_newrelic_api_key" ]]; then
  echo "❌ Error: API_KEY 環境変数が未設定です。"
  echo "エクスポートしてください： export API_KEY=your_api_key"
  exit 1
fi

API_KEY="$TF_VAR_newrelic_api_key"
API_URL="https://api.newrelic.com/v2"
HEADERS=(
  -H "X-Api-Key:${API_KEY}"
  -H "Content-Type: application/json"
)
ALERT_STATE="true"

# ====== 全アラートポリシーを取得 ======
echo "🔍 Fetching all alert policies..."
POLICIES=$(curl -s "${API_URL}/alerts_policies.json" "${HEADERS[@]}")
POLICY_IDS=$(echo "$POLICIES" | jq -r '.policies[].id')

if [ -z "$POLICY_IDS" ]; then
  echo "⚠️ No policies found."
  exit 1
fi

# ====== 各ポリシーに対してアラート条件を取得し、無効化 ======
for POLICY_ID in $POLICY_IDS; do
  echo "📘 Processing policy ID: $POLICY_ID"
  CONDITIONS_JSON=$(curl -s "${API_URL}/alerts_nrql_conditions.json" -G -d "policy_id=${POLICY_ID}" "${HEADERS[@]}")
  CONDITION_IDS=$(echo "$CONDITIONS_JSON" | jq -r '.nrql_conditions[].id')

  for CONDITION_ID in $CONDITION_IDS; do
    ALL_CONDITIONS=$(curl -s "${API_URL}/alerts_nrql_conditions.json?policy_id=${POLICY_ID}" "${HEADERS[@]}")
    CONDITION=$(echo "$ALL_CONDITIONS" | jq ".nrql_conditions[] | select(.id == ${CONDITION_ID})")
    
    PAYLOAD=$(echo "$CONDITION" | jq --argjson enabled "$ALERT_STATE" '
    {
        nrql_condition: {
            name: .name,
            runbook_url: .runbook_url,
            enabled: $enabled,
            terms: .terms,
            value_function: .value_function,
            nrql: .nrql
        }
    }
    ')
    echo $PAYLOAD

    echo "🚫 Updating condition ID: $CONDITION_ID"
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT \
      "${API_URL}/alerts_nrql_conditions/${CONDITION_ID}.json" \
      "${HEADERS[@]}" \
      -d "$PAYLOAD")

    if [ "$RESPONSE" -eq 200 ]; then
      echo "✅ Successfully disabled condition ID: $CONDITION_ID"
    else
      echo "❌ Failed to disable condition ID: $CONDITION_ID (HTTP $RESPONSE)"
    fi
  done
done
