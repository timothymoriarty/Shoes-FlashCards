class Problem
	
	def initialize(x, y, z)
		@x = x
		@y = y
		@your_answer = z
		@the_answer = x * y
	end
	
	def x
		@x
	end
	
	def y
		@y
	end
	
	def your_answer
		@your_answer
	end
	
	def the_answer
		@the_answer
	end
	
	def correct?
		(@your_answer == @the_answer)
	end
	
	def to_s
		@x.to_s << " x " << @y.to_s << " = " << @your_answer.to_s
	end
end

class FlashCards < Shoes
	
	url '/', :app_start
	url '/show_card', :show_card
	url '/results_page', :results_page
	@@counter = 0
	@@problems = Array.new
	@@time = Time.now
	
	def app_start
		title link("Click to start", :click => "/show_card")
	end
	
	def show_card
		flow do
			stack :width => 0.33 do
				title "x", :align => "right", :size => 64, :top => 110
			end
			stack :width => 0.33 do
				if @@counter == 0
					@@time = Time.now
				end
				@x = rand(12)
				@y = rand(12)
				@answer = @x * @y
				title @x, :align => "right", :size => 64
				title @y, :align => "right", :size => 64
				strokewidth(5)
				line(-50, 215, 95, 215)
				
				@type_in = title "", :align => "right", :size => 64

				
				keypress do |key|
					if key.inspect == ':backspace'
						@type_in.text = @type_in.text.chop
					elsif key.inspect == '"\n"'
						@@counter = @@counter + 1
						if @@counter == 20
							add_problem(@x, @y, @type_in.text.to_i)
							visit("/results_page")
						else
							add_problem(@x, @y, @type_in.text.to_i)
							visit("/show_card")
						end
					else
						if (key =~ /[0-9]/) == 0
							@type_in.text += key
						end
					end
				end	
			end
			stack :width => 0.33 do
			end
		end
	end
	
	def results_page
		para (strong (Time.now - @@time).to_s, " seconds\n\n")
		@correct = 0
		@@problems.each do |problem|

			if problem.correct?
				@correct = @correct + 1
				para problem.to_s, "\n"
			else
				para problem.to_s, " The correct answer is ", problem.the_answer.to_s, "\n", :stroke => red
			end
		end
		
		para "You got ", @correct.to_s, " correct out of ", @@problems.size.to_s, "\n"
		@@counter = 0
		@@problems.clear
		title link("Click to start", :click => "/show_card")
	end
	
	def add_problem(x, y, your_answer)
		@@problems.push(Problem.new x, y, your_answer)
	end
end

Shoes.app :width => 300, :height => 600,
  :title => "Flash Cards"