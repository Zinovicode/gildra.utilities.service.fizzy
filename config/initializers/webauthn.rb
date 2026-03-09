Rails.application.config.to_prepare do
  ActionPack::Passkey.include ActionPackWebAuthnInferPasskeyName
end
