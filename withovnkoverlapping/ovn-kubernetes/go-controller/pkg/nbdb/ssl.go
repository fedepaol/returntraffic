// Code generated by "libovsdb.modelgen"
// DO NOT EDIT.

package nbdb

import "github.com/ovn-org/libovsdb/model"

// SSL defines an object in SSL table
type SSL struct {
	UUID            string            `ovsdb:"_uuid"`
	BootstrapCaCert bool              `ovsdb:"bootstrap_ca_cert"`
	CaCert          string            `ovsdb:"ca_cert"`
	Certificate     string            `ovsdb:"certificate"`
	ExternalIDs     map[string]string `ovsdb:"external_ids"`
	PrivateKey      string            `ovsdb:"private_key"`
	SSLCiphers      string            `ovsdb:"ssl_ciphers"`
	SSLProtocols    string            `ovsdb:"ssl_protocols"`
}

func copySSLExternalIDs(a map[string]string) map[string]string {
	if a == nil {
		return nil
	}
	b := make(map[string]string, len(a))
	for k, v := range a {
		b[k] = v
	}
	return b
}

func equalSSLExternalIDs(a, b map[string]string) bool {
	if (a == nil) != (b == nil) {
		return false
	}
	if len(a) != len(b) {
		return false
	}
	for k, v := range a {
		if w, ok := b[k]; !ok || v != w {
			return false
		}
	}
	return true
}

func (a *SSL) DeepCopyInto(b *SSL) {
	*b = *a
	b.ExternalIDs = copySSLExternalIDs(a.ExternalIDs)
}

func (a *SSL) DeepCopy() *SSL {
	b := new(SSL)
	a.DeepCopyInto(b)
	return b
}

func (a *SSL) CloneModelInto(b model.Model) {
	c := b.(*SSL)
	a.DeepCopyInto(c)
}

func (a *SSL) CloneModel() model.Model {
	return a.DeepCopy()
}

func (a *SSL) Equals(b *SSL) bool {
	return a.UUID == b.UUID &&
		a.BootstrapCaCert == b.BootstrapCaCert &&
		a.CaCert == b.CaCert &&
		a.Certificate == b.Certificate &&
		equalSSLExternalIDs(a.ExternalIDs, b.ExternalIDs) &&
		a.PrivateKey == b.PrivateKey &&
		a.SSLCiphers == b.SSLCiphers &&
		a.SSLProtocols == b.SSLProtocols
}

func (a *SSL) EqualsModel(b model.Model) bool {
	c := b.(*SSL)
	return a.Equals(c)
}

var _ model.CloneableModel = &SSL{}
var _ model.ComparableModel = &SSL{}
