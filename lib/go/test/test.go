package test

import (
	"io/ioutil"
	"testing"

	emulator "github.com/onflow/flow-emulator"
	"github.com/onflow/flow-go-sdk"
	"github.com/onflow/flow-go-sdk/templates"
	"github.com/stretchr/testify/require"
)

func deployFCLCryptoContract(t *testing.T, b *emulator.Blockchain) flow.Address {
	code := fclCryptoContract()
	address, err := b.CreateAccount(nil,
		[]templates.Contract{
			{
				Name:   "FCLCrypto",
				Source: string(code),
			},
		},
	)
	require.NoError(t, err)

	_, err = b.CommitBlock()
	require.NoError(t, err)

	return address
}

// newEmulator returns a emulator object for testing
func newEmulator() *emulator.Blockchain {
	b, err := emulator.NewBlockchain()
	if err != nil {
		panic(err)
	}
	return b
}

// readFile reads a file from the file system
// and returns its contents
func readFile(path string) []byte {
	contents, err := ioutil.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return contents
}
