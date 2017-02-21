module Transmo

  class Version
    MAJOR = 0
    MINOR = 0
    PATCH = 0

    class << self
      def inspect
        [MAJOR, MINOR, PATCH].join(".")
      end

      alias_method :to_s, :inspect
    end
  end

end
