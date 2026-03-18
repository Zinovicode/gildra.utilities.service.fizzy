module Search::Record::PostgreSQL
  extend ActiveSupport::Concern

  included do
    self.table_name = "search_records"

    before_save :stem_content

    scope :matching, ->(query, account_id) do
      terms = query.split.map { |t| "%#{sanitize_sql_like(t)}%" }
      clause = terms.map { "COALESCE(content, '') || ' ' || COALESCE(title, '') ILIKE ?" }.join(" AND ")
      where(clause, *terms).where(account_id: account_id)
    end
  end

  class_methods do
    def search_fields(query)
      "#{connection.quote(query.terms)} AS query"
    end

    def for(account_id)
      self
    end
  end

  def card_title
    highlight(card.title, show: :full) if card_id
  end

  def card_description
    highlight(card.description.to_plain_text, show: :snippet) if card_id
  end

  def comment_body
    highlight(comment.body.to_plain_text, show: :snippet) if comment
  end

  private
    def stem_content
      self.title = Search::Stemmer.stem(title) if title_changed?
      self.content = Search::Stemmer.stem(content) if content_changed?
    end

    def highlight(text, show:)
      if text.present? && attribute?(:query)
        highlighter = Search::Highlighter.new(query)
        show == :snippet ? highlighter.snippet(text) : highlighter.highlight(text)
      else
        text
      end
    end
end
