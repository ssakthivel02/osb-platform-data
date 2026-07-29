import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
governance = json.loads((root / 'config/data-governance-policy.json').read_text())
privacy = json.loads((root / 'config/privacy-policy.json').read_text())

assert governance['apiPrefix'].startswith('/api/v1/')
assert {'en-GB', 'ta-IN'} <= set(governance['requiredLocales'])
assert governance['tenantIsolation'] is True
assert governance['serverAuthoritativeTenantScope'] is True
assert governance['encryptionAtRest'] is True
assert governance['encryptionInTransit'] is True
assert governance['lineageRequired'] is True
assert governance['schemaVersioningRequired'] is True
assert privacy['dataMinimisation'] is True
assert privacy['deletionWorkflowRequired'] is True
assert privacy['maskingRequiredOutsideProduction'] is True
print('Data governance baseline validation passed')
