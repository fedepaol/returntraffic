// Code generated by "libovsdb.modelgen"
// DO NOT EDIT.

package sbdb

import "github.com/ovn-org/libovsdb/model"

// MACBinding defines an object in MAC_Binding table
type MACBinding struct {
	UUID        string `ovsdb:"_uuid"`
	Datapath    string `ovsdb:"datapath"`
	IP          string `ovsdb:"ip"`
	LogicalPort string `ovsdb:"logical_port"`
	MAC         string `ovsdb:"mac"`
}

func (a *MACBinding) DeepCopyInto(b *MACBinding) {
	*b = *a
}

func (a *MACBinding) DeepCopy() *MACBinding {
	b := new(MACBinding)
	a.DeepCopyInto(b)
	return b
}

func (a *MACBinding) CloneModelInto(b model.Model) {
	c := b.(*MACBinding)
	a.DeepCopyInto(c)
}

func (a *MACBinding) CloneModel() model.Model {
	return a.DeepCopy()
}

func (a *MACBinding) Equals(b *MACBinding) bool {
	return a.UUID == b.UUID &&
		a.Datapath == b.Datapath &&
		a.IP == b.IP &&
		a.LogicalPort == b.LogicalPort &&
		a.MAC == b.MAC
}

func (a *MACBinding) EqualsModel(b model.Model) bool {
	c := b.(*MACBinding)
	return a.Equals(c)
}

var _ model.CloneableModel = &MACBinding{}
var _ model.ComparableModel = &MACBinding{}
