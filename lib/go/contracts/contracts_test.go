package contracts

import (
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"
)

func Test_StorefrontContract(t *testing.T) {
	code := FCLCrypto()
	assert.True(t, strings.Contains(string(code), "pub contract FCLCrypto"))
}
