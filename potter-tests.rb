require 'test/unit'

class TestPotterPricer < Test::Unit::TestCase
	def bookPrice
		8
	end

	def get_book_discounts
		BookDiscounts.new()
			.add(2, 0.95)
			.add(3, 0.90)
			.add(4, 0.80)
			.add(5, 0.75)
	end

	def test_0_book_total_equals_0
		basket = Basket.new()
		target = PotterPricer.new(bookPrice, get_book_discounts)
		assert_equal 0, target.price(basket)
	end

	def test_1_book_one_total_equals_8
		basket = Basket.new()
			.add_book(1)
		target = PotterPricer.new(bookPrice, get_book_discounts)
		assert_equal bookPrice, target.price(basket)
	end

	def test_1_book_two_total_equals_8
		basket = Basket.new()
			.add_book(2)
		target = PotterPricer.new(bookPrice, get_book_discounts)
		assert_equal bookPrice, target.price(basket)
	end

	def test_1_book_three_total_equals_8
		basket = Basket.new()
			.add_book(3)
		target = PotterPricer.new(bookPrice, get_book_discounts)
		assert_equal bookPrice, target.price(basket)
	end

	def test_1_book_four_total_equals_8
		basket = Basket.new()
			.add_book(4)
		target = PotterPricer.new(bookPrice, get_book_discounts)
		assert_equal bookPrice, target.price(basket)
	end

	def test_1_book_five_total_equals_8
		basket = Basket.new()
			.add_book(5)
		target = PotterPricer.new(bookPrice, get_book_discounts)
		assert_equal bookPrice, target.price(basket)
	end

	def test_2_same_books_total_equals_twice_price
		bookId = 1
		basket = Basket.new()
			.add_book(bookId)
			.add_book(bookId)
		target = PotterPricer.new(bookPrice, get_book_discounts)
		assert_equal bookPrice * 2, target.price(basket)
	end

	def test_2_different_books_total_equals_twice_price_minus_5_percent
		book_discounts = get_book_discounts()
		basket = Basket.new()
			.add_book(1)
			.add_book(2)
		target = PotterPricer.new(bookPrice, book_discounts)
		assert_equal (bookPrice * 2) * book_discounts.get_discount_percentage_for(2), target.price(basket)
	end

	def test_3_different_books_total_equals_three_times_price_minus_10_percent
		book_discounts = get_book_discounts()
		basket = Basket.new()
			.add_book(1)
			.add_book(2)
			.add_book(3)
		target = PotterPricer.new(bookPrice, book_discounts)
		assert_equal (bookPrice * 3) * book_discounts.get_discount_percentage_for(3), target.price(basket)
	end

	def test_4_different_books_total_equals_four_times_price_minus_10_percent
		book_discounts = get_book_discounts()
		basket = Basket.new()
			.add_book(1)
			.add_book(2)
			.add_book(3)
			.add_book(4)
		target = PotterPricer.new(bookPrice, book_discounts)
		assert_equal (bookPrice * 4) * book_discounts.get_discount_percentage_for(4), target.price(basket)
	end

	def test_5_different_books_total_equals_four_times_price_minus_10_percent
		book_discounts = get_book_discounts()
		basket = Basket.new()
			.add_book(1)
			.add_book(2)
			.add_book(3)
			.add_book(4)
			.add_book(5)
		target = PotterPricer.new(bookPrice, book_discounts)
		assert_equal (bookPrice * 5) * book_discounts.get_discount_percentage_for(5), target.price(basket)
	end
end

class PotterPricer
	def initialize(price, book_discounts)		
		price_calculator = NoDiscountPriceCalculator.new(price)
		@discount_price_calculator = StandardDiscountPriceCalculator.new(price_calculator, book_discounts)
	end

	def price(basket)
		return @discount_price_calculator.calculate(basket)
	end
end

class NoDiscountPriceCalculator
	def initialize(price)
		@price = price
	end

	def calculate(basket)
		basket.books.length * @price
	end
end

class StandardDiscountPriceCalculator
	def initialize(price_calculator, book_discounts)
		@price_calculator = price_calculator
		@book_discounts = book_discounts
	end

	def calculate(basket)
		@price_calculator.calculate(basket) * @book_discounts.get_discount_percentage_for(basket.books.uniq.length) 
	end
end


class BookDiscounts
	def initialize()
		@discount_amounts = Hash.new()
	end

	def add(number_of_unique_books, discount_amount)
		@discount_amounts[number_of_unique_books] = discount_amount
		self
	end

	def get_discount_percentage_for(number_of_unique_books)
		@discount_amounts.include?(number_of_unique_books) ? @discount_amounts[number_of_unique_books] : 1
	end
end

class Basket
	attr_reader :books

	def initialize()
		@books = []
	end

	def add_book(bookId)
		@books.push(bookId)
		self
	end
end

