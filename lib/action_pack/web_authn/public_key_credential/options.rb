class ActionPack::WebAuthn::PublicKeyCredential::Options
  include ActiveModel::API

  CHALLENGE_LENGTH = 32
  USER_VERIFICATION_OPTIONS = %i[ required preferred discouraged ].freeze

  attr_accessor :user_verification, :relying_party

  validates :user_verification, inclusion: { in: USER_VERIFICATION_OPTIONS }

  def initialize(attributes = {})
    super
    @user_verification = (@user_verification || :preferred).to_sym
    @relying_party ||= ActionPack::WebAuthn.relying_party
  end

  def validate!
    super
  rescue ActiveModel::ValidationError
    raise ActionPack::WebAuthn::InvalidOptionsError, errors.full_messages.to_sentence
  end

  # Returns a Base64URL-encoded random challenge. The challenge is generated
  # once and memoized for the lifetime of this object.
  #
  # The challenge must be stored server-side and verified when the client
  # responds, to prevent replay attacks.
  def challenge
    @challenge ||= Base64.urlsafe_encode64(
      SecureRandom.random_bytes(CHALLENGE_LENGTH),
      padding: false
    )
  end
end
