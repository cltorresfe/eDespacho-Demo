class OpenGuide < ActiveRecord::Base
	def self.folios_gaps(cantidad)
    select("(folio + 1) as Folio").
    where("NOT EXISTS
        (
        SELECT  NULL
        FROM    open_guides mi 
        WHERE   mi.folio = open_guides.folio + 1
        )").first(cantidad)
  end
end
