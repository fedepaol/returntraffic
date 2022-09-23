// Code generated by mockery v1.0.0. DO NOT EDIT.

package mocks

import (
	io "io"

	types "github.com/containernetworking/cni/pkg/types"
	mock "github.com/stretchr/testify/mock"
)

// Result is an autogenerated mock type for the Result type
type Result struct {
	mock.Mock
}

// GetAsVersion provides a mock function with given fields: version
func (_m *Result) GetAsVersion(version string) (types.Result, error) {
	ret := _m.Called(version)

	var r0 types.Result
	if rf, ok := ret.Get(0).(func(string) types.Result); ok {
		r0 = rf(version)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(types.Result)
		}
	}

	var r1 error
	if rf, ok := ret.Get(1).(func(string) error); ok {
		r1 = rf(version)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// Print provides a mock function with given fields:
func (_m *Result) Print() error {
	ret := _m.Called()

	var r0 error
	if rf, ok := ret.Get(0).(func() error); ok {
		r0 = rf()
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// PrintTo provides a mock function with given fields: writer
func (_m *Result) PrintTo(writer io.Writer) error {
	ret := _m.Called(writer)

	var r0 error
	if rf, ok := ret.Get(0).(func(io.Writer) error); ok {
		r0 = rf(writer)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// Version provides a mock function with given fields:
func (_m *Result) Version() string {
	ret := _m.Called()

	var r0 string
	if rf, ok := ret.Get(0).(func() string); ok {
		r0 = rf()
	} else {
		r0 = ret.Get(0).(string)
	}

	return r0
}
