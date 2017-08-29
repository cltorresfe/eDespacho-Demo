class CreditNote < ActiveRecord::Base
	def self.find_credit_note(type_doc, folio)
		where(type_doc: type_doc.to_s, folio: folio).take
  end
end