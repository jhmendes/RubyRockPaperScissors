require "sinatra"
require 'pry'


set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/' do
  if
    session[:playerscore] == 2 || session[:computerscore] == 2
    session.clear
    redirect '/'
  elsif
    session[:playerscore].nil?
    session[:playerscore] = 0
    session[:computerscore] = 0
  end
  erb :index
end

get '/winner' do

  if session[:playerscore] == 2
    @winner = "Player Wins the Game!!!"
    @score = "Player: #{session[:playerscore]} Computer: #{session[:computerscore]}"
  elsif
    session[:computerscore] == 2
    @winner = "Computer Wins the Game!!!"
    @score = "Computer: #{session[:computerscore]} Player: #{session[:playerscore]}"
  end
  erb :winner
end

post '/choose' do

  @playerchoice = params[:choice]
  @computerchoice = ["Rock", "Paper", "Scissors"].sample

    if @playerchoice == "Rock" && @computerchoice == "Scissors" || @playerchoice == "Paper" && @computerchoice == "Rock" || @playerchoice == "Scissors" && @computerchoice == "Paper"
      session[:game_message] = "You chose #{@playerchoice}, Computer chose #{@computerchoice}.  You Win the Round!"
      session[:playerscore] += 1
    elsif
      @playerchoice == "Rock" && @computerchoice == "Paper" ||  @playerchoice == "Paper" && @computerchoice == "Scissors" || @playerchoice == "Scissors" && @computerchoice == "Rock"
      session[:game_message] = "You chose #{@playerchoice}, Computer chose #{@computerchoice},  Computer Wins the Round!"
      session[:computerscore] += 1
    else
      session[:game_message] = "You both chose #{@playerchoice}, its a Tie!"
    end

    if session[:playerscore] == 2
      redirect '/winner'
    elsif
      session[:computerscore] == 2
      redirect '/winner'
    end

    redirect '/'

end
