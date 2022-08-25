import FlowInteractionTemplateAudit from "./contracts/FlowInteractionTemplateAudit.cdc"

transaction() {
  prepare(auditor: AuthAccount) {
    if auditor.borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager>(from: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath) == nil {
      let FlowInteractionTemplateAuditManager <- FlowInteractionTemplateAudit.createFlowInteractionTemplateAuditManager()

      auditor.save(
        <- FlowInteractionTemplateAuditManager, 
        to: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath,
      )
            
      auditor.link<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>(
        FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath,
        target: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath
      )

      auditor.link<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}>(
        FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivatePath,
        target: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath
      )
    } else {
      panic("Cannot create new FlowInteractionTemplateAuditManager, one already exists.")
    }
  }
}