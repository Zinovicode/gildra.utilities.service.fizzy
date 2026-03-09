module ActionPack::Passkey::FormHelper
  def passkey_creation_options_meta_tag(creation_options)
    tag.meta(name: "passkey-creation-options", content: creation_options.to_json)
  end

  def passkey_request_options_meta_tag(request_options)
    tag.meta(name: "passkey-request-options", content: request_options.to_json)
  end

  def create_passkey_button(label = nil, url, param: :passkey, form: {}, **options, &block)
    button_content = block ? capture(&block) : label
    form_options = form.reverse_merge(method: :post, action: url, class: "button_to")

    tag.form(**form_options) do
      safe_join([
        hidden_field_tag(:authenticity_token, form_authenticity_token),
        hidden_field_tag("#{param}[client_data_json]", nil, id: nil, data: { passkey_field: "client_data_json" }),
        hidden_field_tag("#{param}[attestation_object]", nil, id: nil, data: { passkey_field: "attestation_object" }),
        hidden_field_tag("#{param}[transports][]", nil, id: nil, data: { passkey_field: "transports" }),
        tag.button(button_content, type: :button, data: { passkey: "create" }, **options)
      ])
    end
  end

  def sign_in_with_passkey_button(label = nil, url, param: :passkey, mediation: nil, form: {}, **options, &block)
    button_content = block ? capture(&block) : label
    form_data = {}
    form_data[:passkey_mediation] = mediation if mediation
    form_options = form.reverse_merge(method: :post, action: url, class: "button_to", data: form_data)

    tag.form(**form_options) do
      safe_join([
        hidden_field_tag(:authenticity_token, form_authenticity_token),
        hidden_field_tag("#{param}[id]", nil, id: nil, data: { passkey_field: "id" }),
        hidden_field_tag("#{param}[client_data_json]", nil, id: nil, data: { passkey_field: "client_data_json" }),
        hidden_field_tag("#{param}[authenticator_data]", nil, id: nil, data: { passkey_field: "authenticator_data" }),
        hidden_field_tag("#{param}[signature]", nil, id: nil, data: { passkey_field: "signature" }),
        tag.button(button_content, type: :button, data: { passkey: "sign_in" }, **options)
      ])
    end
  end
end
