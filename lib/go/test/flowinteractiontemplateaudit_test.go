package test

import (
	"testing"
	"github.com/stretchr/testify/assert"
)


func TestDeployFlowInteractionTemplateAuditContract(t *testing.T) {
	t.Run("deploy FlowInteractionTemplateAuditContract", func(t *testing.T) {
		b := newEmulator()
		deployFlowInteractionTemplateAuditContract(t, b)
		assert.Equal(t, true, true)
	})
}