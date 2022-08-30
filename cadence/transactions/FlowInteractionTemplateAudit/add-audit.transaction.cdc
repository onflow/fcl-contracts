import FlowInteractionTemplateAudit from "./contracts/FlowInteractionTemplateAudit.cdc"

transaction(templateId: String) {
  let flowInteractionTemplateAuditManagerPrivateRef: &FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPrivate}
  prepare(account: AuthAccount) {
    if account.borrow<&FlowInteractionTemplateAudit.AuditManager>(from: FlowInteractionTemplateAudit.AuditManagerStoragePath) == nil {
      let FlowInteractionTemplateAuditManager <- FlowInteractionTemplateAudit.createAuditManager()

      account.save(
        <- FlowInteractionTemplateAuditManager, 
        to: FlowInteractionTemplateAudit.AuditManagerStoragePath,
      )
            
      account.link<&FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPublic}>(
        FlowInteractionTemplateAudit.AuditManagerPublicPath,
        target: FlowInteractionTemplateAudit.AuditManagerStoragePath
      )

      account.link<&FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPrivate}>(
        FlowInteractionTemplateAudit.AuditManagerPrivatePath,
        target: FlowInteractionTemplateAudit.AuditManagerStoragePath
      )
    }

    self.flowInteractionTemplateAuditManagerPrivateRef = 
      account.borrow<&FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPrivate}>(from: FlowInteractionTemplateAudit.AuditManagerStoragePath)
        ?? panic("Could not borrow ref to AuditManagerPrivate")
  }

  execute {
    self.flowInteractionTemplateAuditManagerPrivateRef.addAudit(templateId: templateId)
  }
}