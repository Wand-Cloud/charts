{{- define "customerID" -}}
{{- .Values.customerID | required ".Values.customerID is required." -}}
{{- end }}

{{- define "clusterID" -}}
{{- .Values.clusterID | required ".Values.clusterID is required." -}}
{{- end }}

{{- define "auth.filePath" -}}
{{- range .Values.prometheus.server.extraSecretMounts }}
  {{- if eq .name "auth-file" }}
    {{- .mountPath }}/token
  {{- end }}
{{- end }}
{{- end }}

{{- define "auth.secretName" -}}
{{- range .Values.prometheus.server.extraSecretMounts }}
  {{- if eq .name "auth-file" }}
    {{- .secretName }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "auth.username" -}}
{{ .Values.customerID }}
{{- end }}

{{- define "saas.endpoint" -}}
{{ $url := printf "https://%s-ingest.app.wand.cloud" .Values.customerID -}}
{{ default $url .Values.urlOverride}}
{{- end }}

{{- define "mutator.image" -}}
{{ .Values.mutator.image.repository }}:{{ .Values.mutator.image.tag }}
{{- end }}

{{- define "controller.image" -}}
{{ .Values.controller.image.repository }}:{{ .Values.controller.image.tag }}
{{- end }}

{{- define "mutator.fullname" -}}
{{- printf "%s-%s" (include "wand.fullname" .) .Values.mutator.name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "controller.fullname" -}}
{{- printf "%s-%s" (include "wand.fullname" .) .Values.controller.name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "api.url" -}}
{{- if .Values.controller.apiUrlOverride -}}
  {{ .Values.controller.apiUrlOverride }}
{{- else -}}
  {{ include "saas.endpoint" .}}
{{- end }}
{{- end }}

{{- define "rbac.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1" }}
{{- print "rbac.authorization.k8s.io/v1" -}}
{{- else -}}
{{- print "rbac.authorization.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}
