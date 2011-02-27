module Localness
  PORTLAND_SUBURBS = ["beaverton", "gresham", "hillsboro", "clackamas",
                      "damascus", "gladstone", "king city", "lake oswego",
                      "milwaukie", "oregon city", "sherwood", "tigard",
                      "troutdale", "tualatin", "west linn", "wilsonville",
                      "aloha"]

  def localness(person)
    location = person.location.try(:downcase) || ''
    if %w(portland pdx stumptown).any?{|term| location.include?(term) }
      return 5
    elsif PORTLAND_SUBURBS.any?{|term| location.include?(term) }
      return 4
    elsif %w(oregon washington or wa).any?{|term| location.include?(term) }
      return 3
    else
      return 0
    end
  end
end
