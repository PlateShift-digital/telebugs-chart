{{- define "registryContent" -}}
{
  "auths": {
    "{{.Values.registry.host}}": {
      "auth": "{{(printf "%s:%s" .Values.registry.user .Values.registry.password)|b64enc}}"
    }
  }
}
{{- end -}}
