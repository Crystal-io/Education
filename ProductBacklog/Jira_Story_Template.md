# Story: <Story Name>

## 1. User Story
As a <role>,
I want <capability/action>,
So that <business/user value>.

## 2. Business Context
Why is this Story needed?
What problem does it solve?
How does it support the Epic goal?

## 3. User / Role
- Primary role:
- Secondary roles:
- System actor, if applicable:
- Tenant/market/product limitations:

## 4. Preconditions
- ...
- ...

## 5. Postconditions
- ...
- ...

## 6. Main Flow
1. ...
2. ...
3. ...

## 7. Alternative Flows
### A1. <Alternative flow name>
1. ...
2. ...

### A2. <Alternative flow name>
1. ...
2. ...

## 8. Edge Cases
| Case | Expected behavior |
|---|---|
| | |

## 9. Functional Requirements
| FR ID | Requirement |
|---|---|
| FR-001 | System shall ... |
| FR-002 | System shall ... |

## 10. Business Rules
| BR ID | Rule |
|---|---|
| BR-001 | |
| BR-002 | |

## 11. Acceptance Criteria
### AC-001: <Name>
Given ...
When ...
Then ...

### AC-002: <Name>
Given ...
When ...
Then ...

## 12. Validation Rules
| Field / Object | Rule | Error message |
|---|---|---|
| | | |

## 13. Permissions / Access Control
| Role | View | Create | Edit | Delete | Approve | Export |
|---|---|---|---|---|---|---|
| Admin | | | | | | |
| Manager | | | | | | |
| Agent | | | | | | |

### Permission failure behavior
- ...

## 14. Logging Requirements
| Event | Trigger | Level | Required fields |
|---|---|---|---|
| | | | |

Required common fields:
- userId
- tenantId
- entityId
- action
- timestamp
- requestId/correlationId
- result
- errorCode/errorMessage if failed

## 15. Audit Requirements
- Should this action be auditable? Yes/No
- Audit event name:
- Old/new values required? Yes/No
- Who can view audit record?
- Retention period:

## 16. Integration Points
| System | Interaction | Sync/Async | Contract link |
|---|---|---|---|
| | | | |

## 17. API / Event Details
- Endpoint:
- Method:
- Request:
- Response:
- Error codes:
- Event name:
- Event payload:
- Idempotency:
- Retry behavior:

## 18. Data Requirements
| Field | Type | Required | Source | Notes |
|---|---|---|---|---|
| | | | | |

## 19. UI/UX
- Figma link:
- Screens:
- Components:
- UI states:
  - Default:
  - Loading:
  - Empty:
  - Error:
  - Success:
  - Disabled:

## 20. Notifications / Communication
- Trigger:
- Channel:
- Template:
- Recipient:
- Localization:
- Retry/failure behavior:

## 21. Non-Functional Requirements
| Category | Requirement |
|---|---|
| Performance | |
| Security | |
| Availability | |
| Scalability | |
| Localization | |
| Accessibility | |
| Compliance | |
| Data retention | |

## 22. Analytics
- Business event:
- Properties:
- Funnel/metric affected:
- Dashboard/report impact:

## 23. Dependencies
| Dependency | Type | Owner | Status |
|---|---|---|---|
| | | | |

## 24. Test Notes / QA Focus
- Positive scenarios:
- Negative scenarios:
- Regression areas:
- Test data:
- Environments:
- Test case links:

## 25. Open Questions
| Question | Owner | Due date | Status |
|---|---|---|---|
| | | | |

## 26. Out of Scope
- ...

## 27. Links
- Epic:
- Confluence requirement:
- Figma:
- API spec:
- Data model:
- Access matrix:
- Test cases:
- Related issues:

## 28. Story Definition of Ready
- [ ] User role and value are clear
- [ ] Scope is clear
- [ ] Main flow is described
- [ ] Alternative flows / edge cases are described
- [ ] Acceptance Criteria are testable
- [ ] Business rules are documented or linked
- [ ] Functional requirements are documented or linked
- [ ] Permissions are defined
- [ ] Logging/audit requirements are defined or marked N/A
- [ ] NFRs are defined or marked N/A
- [ ] UX/UI is attached or not required
- [ ] Integration/data impact is clear
- [ ] Dependencies are known
- [ ] QA understands how to test
- [ ] Story is estimated
- [ ] Story is small enough for one sprint

## 29. Story Definition of Done
- [ ] All Acceptance Criteria pass
- [ ] Business rules work as expected
- [ ] Permissions work as expected
- [ ] Validation messages are correct
- [ ] Logging/audit requirements are implemented
- [ ] UI behavior matches approved design if applicable
- [ ] API/integration behavior matches contract if applicable
- [ ] QA testing is completed
- [ ] Regression impact is checked
- [ ] Documentation/test cases are updated if required
- [ ] PO/BSA accepted the Story