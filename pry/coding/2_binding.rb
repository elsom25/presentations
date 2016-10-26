class Money
  def reversible_exchange_to(other_currency)
    other_currency = Currency.wrap(other_currency)
    @bank.reversible_exchange_with(self, other_currency)
  end

  module Bank
    class StableExchange
      def get_reversible_rate(from, to)
        1.to_r / get_rate(to, from).to_r
      end

      def reversible_exchange_with(from, to_currency)
        return from if same_currency?(from.currency, to_currency)

        rate = get_reversible_rate(from.currency, to_currency)
        unless rate
          raise UnknownRate, "No conversion rate known for '#{from.currency.iso_code}' -> '#{to_currency}'"
        end
        _to_currency_  = Currency.wrap(to_currency)

        binding.pry

        cents = from.cents.to_r / (from.currency.subunit_to_unit.to_r / _to_currency_.subunit_to_unit.to_r)

        ex = cents * rate
        ex = ex.to_f
        ex = if block_given?
               yield ex
             elsif @rounding_method
               @rounding_method.call(ex)
             else
               ex.floor
             end
        Money.new(ex, _to_currency_)
      end
    end
  end
end
