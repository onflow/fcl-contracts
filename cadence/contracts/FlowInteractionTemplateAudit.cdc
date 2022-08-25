/*
  FlowInteractionTemplateAudit

  The FlowInteractionTemplateAudit contract manages the creation 
  of InteractionTemplateAuditManager resources. It also maintains some
  helpful utilities for querying from InteractionTemplateAuditManager 
  resouces.

  FlowInteractionTemplateAuditManager resouces maintain the IDs of
  InteractionTemplate data structures that have been audited by the
  owner of the InteractionTemplateAuditManager. The owner of an
  InteractionTemplateAuditManager resource is consididered an 
  Interaction Template Auditor.

  See additional documentation: https://github.com/onflow/fcl-contracts
*/

pub contract FlowInteractionTemplateAudit {

  /****** Audit Events ******/

  // The event that is emitted when an audit is added to an 
  // InteractionTemplateAuditManager.
  // 
  pub event AuditAdded(templateId: String, auditor: Address, auditManagerID: UInt64)

  // The event that is emitted when an audit is revoked from an 
  // InteractionTemplateAuditManager.
  // 
  pub event AuditRevoked(templateId: String, auditor: Address, auditManagerID: UInt64)

  // The event that is emitted when an InteractionTemplateAuditManager
  // is created.
  // 
  pub event AuditorCreated(auditManagerID: UInt64)

  /****** Storage Paths ******/

  pub let FlowInteractionTemplateAuditManagerStoragePath: StoragePath
  pub let FlowInteractionTemplateAuditManagerPublicPath: PublicPath
  pub let FlowInteractionTemplateAuditManagerPrivatePath: PrivatePath

  // Public Interface for FlowInteractionTemplateManager.
  //
  // Maintains the publically accessible methods on an
  // InteractionTemplateAuditManager resource.
  //
  pub resource interface FlowInteractionTemplateAuditManagerPublic {
    pub fun getAudits(): [String]
    pub fun getHasAuditedTemplate(templateId: String): Bool
  }

  // Private Interface for FlowInteractionTemplateManager.
  //
  // Maintains the private methods on an
  // InteractionTemplateAuditManager resource. These methods 
  // must be only accessible by the owner of the InteractionTemplateAuditManager
  //
  pub resource interface FlowInteractionTemplateAuditManagerPrivate {
    pub fun addAudit(templateId: String)
    pub fun revokeAudit(templateId: String)
  }

  // The InteractionTemplateAuditManager resource.
  //
  // Maintains the IDs of the InteractionTemplate the owner of the 
  // InteractionTemplateAuditManager has audited.
  //
  pub resource FlowInteractionTemplateAuditManager: FlowInteractionTemplateAuditManagerPublic, FlowInteractionTemplateAuditManagerPrivate {
    
    // Maintains the set of Interaction Template IDs that the owner of this 
    // FlowInteractionTemplateAuditManager has audited.
    //
    // Represents a map from Interaction Template IDs (String) => isAudited (Bool).
    // The value of each element of the map is Boolean 'true'.
    // This is a map as to allow for cheaper lookups, inserts and removals.
    //
    access(self) var audits: {String:Bool}
    
    init() {
      // Initialize the set of audits maintained by this FlowInteractionTemplateAuditManager
      self.audits = {}
      emit AuditorCreated(auditManagerID: self.uuid)
    }

    // Returns the Interaction Template IDs that the owner of this 
    // FlowInteractionTemplateAuditManager has audited.
    //
    // @return An array of Interaction Template IDs that the owner of this 
    // FlowInteractionTemplateAuditManager has audited.
    //
    pub fun getAudits(): [String] {
      return self.audits.keys
    }

    // Returns whether the owner of the InteractionTemplateAuditManager has audited
    // a given Interaction Template by ID.
    //
    // @param templateId: ID of an Interaction Template
    //
    // @return Whether the InteractionTemplateAuditManager has templateId as one of the
    // Interaction Template IDs the owner of the InteractionTemplateAuditManager has audited.
    //
    pub fun getHasAuditedTemplate(templateId: String): Bool {
      return self.audits.containsKey(templateId)
    }
  
    // Adds an Interaction Template ID to the InteractionTemplateAuditManager
    // to denote that the Interaction Template it corresponds to has been audited by the
    // owner of the InteractionTemplateAuditManager.
    //
    // @param templateId: ID of an Interaction Template
    //
    pub fun addAudit(templateId: String) {
      pre {
        !self.audits.containsKey(templateId): "Cannot audit template that is already audited"
      }
      self.audits.insert(key: templateId, true)
      emit AuditAdded(templateId: templateId, auditor: self.owner?.address!, auditManagerID: self.uuid)
    }

    // Revoke an Interaction Template ID from the InteractionTemplateAuditManager
    // to denote that the Interaction Template it corresponds to is no longer audited by the
    // owner of the InteractionTemplateAuditManager.
    //
    // @param templateId: ID of an Interaction Template
    //
    pub fun revokeAudit(templateId: String) {
      pre {
        self.audits.containsKey(templateId): "Cannot revoke audit for a template that is not already audited"
      }
      self.audits.remove(key: templateId)
      emit AuditRevoked(templateId: templateId, auditor: self.owner?.address!, auditManagerID: self.uuid)
    }
  }

  // Utility method to create a FlowInteractionTemplateAuditManager resource.
  //
  // @return An FlowInteractionTemplateAuditManager resource
  //
  pub fun createFlowInteractionTemplateAuditManager(): @FlowInteractionTemplateAuditManager {
    return <- create FlowInteractionTemplateAuditManager()
  }

  // Utility method to check which auditors have audited a given Interaction Template ID 
  //
  // @param templateId: ID of an Interaction Template
  // @param auditors: Array of addresses of auditors
  // 
  // @return A map of auditorAddress => isAuditedByAuditor
  //
  pub fun getHasTemplateBeenAuditedByAuditors(templateId: String, auditors: [Address]): {Address:Bool} {
    let audits: {Address:Bool} = {}

    for auditor in auditors {
      let auditManagerRef = getAccount(auditor)
        .getCapability(FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
        .borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>()
        ?? panic("Could not borrow Audit Manager public reference")

      audits.insert(key: auditor, auditManagerRef.getHasAuditedTemplate(templateId: templateId))
    }

    return audits
  }

  // Utility method to get an array of Interaction Template IDs audited by an auditor. 
  //
  // @param auditor: Address of an auditor
  // 
  // @return An array of Interaction Template IDs
  //
  pub fun getAuditsByAuditor(auditor: Address): [String] {
    let auditManagerRef = getAccount(auditor)
      .getCapability(FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
      .borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>()
      ?? panic("Could not borrow Audit Manager public reference")

    return auditManagerRef.getAudits()
  }

  init() { 
    self.FlowInteractionTemplateAuditManagerStoragePath = /storage/FlowInteractionTemplateAuditManagerStoragePath
    self.FlowInteractionTemplateAuditManagerPublicPath = /public/FlowInteractionTemplateAuditManagerPublicPath
    self.FlowInteractionTemplateAuditManagerPrivatePath = /private/FlowInteractionTemplateAuditManagerPrivatePath
  }
}