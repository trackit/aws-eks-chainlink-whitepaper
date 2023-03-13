{{/*
Expand the name of the chart.
*/}}
{{- define "adapters.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "adapters.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "adapters.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "adapters.labels" -}}
helm.sh/chart: {{ include "adapters.chart" . }}
{{ include "adapters.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "adapters.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "adapters.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "adapters.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "adapters.nomics.fullname" -}}
{{ .Values.nomics.name | quote }}
{{- end }}

{{- define "adapters.nomics.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.nomics.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "adapters.cryptocompare.fullname" -}}
{{ .Values.cryptocompare.name | quote }}
{{- end }}

{{- define "adapters.cryptocompare.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.cryptocompare.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "adapters.tiingo.fullname" -}}
{{ .Values.tiingo.name | quote }}
{{- end }}

{{- define "adapters.tiingo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.tiingo.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "adapters.coinmarketcap.fullname" -}}
{{ .Values.coinmarketcap.name | quote }}
{{- end }}

{{- define "adapters.coinmarketcap.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.coinmarketcap.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "adapters.coingecko.fullname" -}}
{{ .Values.coingecko.name | quote }}
{{- end }}

{{- define "adapters.coingecko.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.coingecko.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "adapters.jpegd.fullname" -}}
{{ .Values.jpegd.name | quote }}
{{- end }}

{{- define "adapters.jpegd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.jpegd.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "adapters.bea.fullname" -}}
{{ .Values.bea.name | quote }}
{{- end }}

{{- define "adapters.bea.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adapters.bea.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
