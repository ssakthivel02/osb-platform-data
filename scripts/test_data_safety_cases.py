def accepted(request):
    forbidden = {
        'tenant_override', 'disable_encryption', 'unapproved_export',
        'delete_during_legal_hold', 'retention_override_without_approval',
        'unmasked_production_copy', 'lineage_bypass'
    }
    return not any(request.get(key) for key in forbidden)

cases = [
    {'tenant_override': True},
    {'disable_encryption': True},
    {'unapproved_export': True},
    {'delete_during_legal_hold': True},
    {'retention_override_without_approval': True},
    {'unmasked_production_copy': True},
    {'lineage_bypass': True},
]
assert all(accepted(case) is False for case in cases)
assert accepted({'tenant_override': False, 'unapproved_export': False}) is True
print('Data safety cases passed')
