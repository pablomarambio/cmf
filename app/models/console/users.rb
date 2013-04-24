# coding: utf-8
module Console
	class Users

		class << self
			def order_by_activity limit=100
				User.order("updated_at DESC").limit(limit)
			end

			def order_by_id limit=100
				User.order("id DESC").limit(limit)
			end

			def p_basic u
				"U #{u.id}: [#{u.status}]\t#{u.name || "no name"} (#{u.username || "no username"}), signed_in: #{u.updated_at}"
			end

			def p_extended u
<<-EOF
#{p_basic u}
  sign_in_count: #{u.sign_in_count || 0}
  price: #{u.threshold || "undefined"}
  email: #{u.email || "undefined"}
EOF
			end

			def p_auth_providers u
				user_activity = ""
				count = 0
				ap_activity = u.auth_providers.each do |ap|
					user_activity += "\tAP #{ap.id}: #{ap.provider} (as #{ap.username})"
					user_activity += "\n" unless ++count == u.auth_providers.length
				end
				user_activity
			end

			def p_basic_and_auth_providers u
				"#{p_basic u}#{p_auth_providers u}"
			end

			def p_extended_and_auth_providers u
				"#{p_extended u}#{p_auth_providers u}"
			end
		end

		ORDER_BY_LENGTH = "order_by_".length
		P_LENGTH = "p_".length

		self.public_methods.select do |pm|
			pm.to_s =~ /^order_by/
		end.map{|m|m.to_s}.each do |order_method|
			self.public_methods.select do |pm|
				pm.to_s =~ /^p_\w+/
			end.map{|m|m.to_s}.each do |print_method|
				order_word = order_method[ORDER_BY_LENGTH, order_method.length - ORDER_BY_LENGTH]
				print_word = print_method[P_LENGTH, print_method.length + P_LENGTH]
				class_eval <<-EOM, __FILE__, __LINE__ + 1
					def self.print_#{print_word}_ordered_by_#{order_word}(limit = nil)
						users = #{order_method}(limit)
						users.each{|u| puts p_#{print_word}(u)}
					end
				EOM
			end # print_method
		end # order_method

	end # Users
end # Console