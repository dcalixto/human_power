require "human_power/version"
require "human_power/generator"
require "human_power/rule"
require "human_power/rails" if defined?(Rails)

module HumanPower
  class << self
    # Yields a configuration block.
    # 
    #   HumanPower.configure do |config|
    #     config.base_controller = MyOtherController
    #   end
    def configure(&block)
      yield self
    end

    # Registers a user agent.
    def register_user_agent(key, user_agent_string)
      user_agents[key] = user_agent_string
    end

    # Hash of registered user agents.
    def user_agents
      @user_agents ||= load_user_agents
    end

    # Regular expression to match bot user agents.
    def bot_regex
      @bot_regex ||= begin
        escaped_values = user_agents.values.map { |ua| Regexp.escape(ua) }
        /#{escaped_values.join("|")}/i
      end
    end

    # Returns +true+ if a given user agent is a bot.
    def is_bot?(user_agent)
      !!(user_agent =~ bot_regex)
    end

  private

      # Loads the built-in user agents from crawlers.yml.
      def load_user_agents
        path = File.expand_path("../../user_agents.yml", __FILE__)
        Hash[YAML.load(open(path).read).map { |k, v| [k.to_sym, v] }]
      end
  end
end