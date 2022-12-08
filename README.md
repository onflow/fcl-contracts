# FCL Contracts

`FCLCrypto.cdc` and `FlowInteractionTemplateAudit.cdc` are contracts which revolve around [Interaction Templates](https://forum.onflow.org/t/flip-934-interaction-templates/3080) and can be used by the Flow Client Library (FCL).  
*Interaction Templates* are a concept to alleviate interacting with a contract by handing out descriptive information in a defined textual data structure. Further information can be obtained by following the link above.  
  
`FCLCrypto.cdc` allows to verify the signatures for an account and check that the combined weight of the account keys reaches signing power.  
It provides the function `verifyUserSignatures` for user signatures and the function `verifyAccountProofSignatures` for account proof signatures.  
These functions are accessible by the provided scripts `verifyUserSignatures.cdc` and `verifyAccountProofSignatures.cdc`.  
  
In order to add *Interaction Templates* which shall be audited, use the `FlowInteractionTemplateAudit.cdc` contract and add the template by executing the transaction `add-audit.transaction.cdc` and provide the template id string.  
In order to revoke added audits, call the `revoke-audit.transaction.cdc` transaction.  
  
It's important to note that by executing `add-audit.transaction.cdc`, you've become an *Interaction Template Auditor*, and own an `AuditManager` resource. All audits which you add are bound to this resource.  
  
You can find two scripts, `get-audits-from-audit-manager.script.cdc` returns a string array containing the keys for all the audits bound to the `AuditManager` resource, while `get-has-audited-from-audit-manager.script.cdc` returns a Boolean signaling if the audit manager has audited the given template id.  
Further utility functions in the contract are `getAuditsByAuditor` which takes an auditor address and returns the audits done by that auditor, and `getHasTemplateBeenAuditedByAuditors`, which allows to check for multiple auditor addresses if the given template id has been audited by them.  
  
## Contract Addresses

| Name                           | Testnet              | Mainnet              | Sandbox             |
| ------------------------------ | -------------------- | -------------------- |---------------------|
| `FCLCrypto`                    | `0x74daa6f9c7ef24b1` | `0xb4b82a1c9d21d284` |`0x57b2b89759200677` |
| `FlowInteractionTemplateAudit` | `0xf78bfc12d0a786dc` | `TBD`                | `TBD`               |
