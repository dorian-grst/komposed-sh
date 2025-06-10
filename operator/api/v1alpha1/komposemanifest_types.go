/*
Copyright 2025.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// KomposeManifestSpec defines the desired state of KomposeManifest
type KomposeManifestSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// DockerCompose is the raw YAML content of a docker-compose file.
	DockerCompose string `json:"dockerCompose"`
}

// KomposeManifestStatus defines the observed state of KomposeManifest
type KomposeManifestStatus struct {
	// Deployed indicates whether the conversion was successful
	Deployed bool `json:"deployed,omitempty"`
	// LastError shows any error that happened during conversion
	LastError string `json:"lastError,omitempty"`
}

// +kubebuilder:object:root=true
// +kubebuilder:subresource:status

// KomposeManifest is the Schema for the komposemanifests API
type KomposeManifest struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   KomposeManifestSpec   `json:"spec,omitempty"`
	Status KomposeManifestStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// KomposeManifestList contains a list of KomposeManifest
type KomposeManifestList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []KomposeManifest `json:"items"`
}

func init() {
	SchemeBuilder.Register(&KomposeManifest{}, &KomposeManifestList{})
}
