# frozen_string_literal: true

# class ExampleController
class ExampleController < ApplicationController
  before_action :set_values
  def input; end

  def show
    return unless check
    
    count
    create_message
  end

  private

  def create_message
    @message = "Найденное количество факториалов #{@results.length}."
    @message += ' Недостаточное количество для подтверждения гипотезы.' if @results.length < 4
    @message += ' Гипотеза Симона подтверждена.' if @results.length == 4
  end

  def set_values
    @input = params[:input_value]
    @number = 1
    @factorial = 1
    @num1 = 1
    @num2 = 2
    @num3 = 3
    @results = []
    Struct.new('Results', :factorial_number, :three_numbers, :factorial_value)
  end

  def count
    @input = @input.to_i
    @input = 1 if @input == 0 
    loop do
      define_first_three_numbers
      product == @factorial ? add_result : values_not_equal
      @number += 1
      @factorial *= @number
      break if @number - 1 == @input
    end
    @results
  end

  def product
    @num1 * @num2 * @num3
  end

  def define_first_three_numbers
    @num1 = (@factorial**(1.0 / 3.0)).truncate
    @num2 = @num1 + 1
    @num3 = @num1 + 2
  end

  def add_result
    @results << Struct::Results.new("#{@number}!", [@num1, @num2, @num3].join(', '), product.to_s)
  end

  def values_not_equal
    product < @factorial ? less_than_need : bigger_than_need
    add_result if product == @factorial
  end

  def less_than_need
    loop do
      @num1 += 1
      @num2 += 1
      @num3 += 1
      break if product >= @factorial
    end
  end

  def bigger_than_need
    loop do
      @num1 -= 1
      @num2 -= 1
      @num3 -= 1
      break if product <= @factorial
    end
  end

  # def check
  #   return false unless check_nil
  #   return false unless check_other_errors

  #   true
  # end

  # def check_nil
  #   if @input.nil?
  #     redirect_to(root_path, notice: 'Не переданы параметры')
  #     return false
  #   end
  #   true
  # end

  # def check_other_errors
  #   unless @input.match?(/^(\d|[1-9]\d+)$/)
  #     if @input.empty?
  #       redirect_to(root_path, notice: 'Введена пустая строка')
  #     else
  #       redirect_to(root_path, notice: 'Введён символ, отличный от цифры')
  #     end
  #     return false
  #   end
  #   true
  # end

  def check_nil
    false
    return true if @input.nil?
  end

  def check_empty
    false
    return true if @input.empty?
  end

  def check_other_errors
    false
    return true if (!@input.empty? && !@input.match?(/^(\d|[1-9]\d+)$/))
  end

  def check
    nil_input = check_nil
    empty_input = check_empty
    other_error = check_other_errors
    if (nil_input || empty_input || other_error)
      redirect_to(root_path, notice: create_error_msg(nil_input, empty_input, other_error))
      return false
    end
    true
  end  

  def create_error_msg(nil_input, empty_input, other_error)
    return 'Не переданы параметры' if nil_input == true
    return 'Введена пустая строка' if empty_input == true
    return 'Введён символ, отличный от цифры' if other_error == true
  end
end
