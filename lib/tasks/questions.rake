namespace :questions do
  desc 'Associates questions to a post'
  task :associate_to_post => :environment do
    Question.includes({item: :post}).find_each do |question|
      question.post = question.item.post
      question.save
    end
  end
end
