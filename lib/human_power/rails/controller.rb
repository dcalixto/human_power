module HumanPower
  module Rails
    ::Rails.application.config.after_initialize do
    class RobotsController < ::ApplicationController
      def robots
        generator = HumanPower::Generator.new(self) do
          file = ::Rails.root.join("config", "robots.rb").to_s
          instance_eval open(file).read, file
        end

        render plain: generator.render
      end
    end
    end
  end
end
