import FlowInteractionTemplateAudit from "./contracts/FlowInteractionTemplateAudit.cdc"

transaction() {
  prepare(auditor: AuthAccount) {
    if auditor.borrow<&FlowInteractionTemplateAudit.AuditManager>(from: FlowInteractionTemplateAudit.AuditManagerStoragePath) == nil {
      let FlowInteractionTemplateAuditManager <- FlowInteractionTemplateAudit.createAuditManager()

      auditor.save(
        <- FlowInteractionTemplateAuditManager, 
        to: FlowInteractionTemplateAudit.AuditManagerStoragePath,
      )
            
      auditor.link<&FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPublic}>(
        FlowInteractionTemplateAudit.AuditManagerPublicPath,
        target: FlowInteractionTemplateAudit.AuditManagerStoragePath
      )

      auditor.link<&FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPrivate}>(
        FlowInteractionTemplateAudit.AuditManagerPrivatePath,
        target: FlowInteractionTemplateAudit.AuditManagerStoragePath
      )
    } else {
      panic("Cannot create new AuditManager, one already exists.")
    }
  }
}