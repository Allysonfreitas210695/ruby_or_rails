namespace :dev do
  desc 'configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('apagando BD...', 'banco apagando com sucesso!') { `rails db:drop` }
      show_spinner('Criando o BD...', 'BD criando com sucesso!') { `rails db:create` }
      show_spinner('migrando o Spinner...', 'migração com sucesso!') { `rails db:migrate` }
      `rails dev:add_mining_type`
      `rails dev:add_coins`
    else
      puts 'Você não está em desenvolvimento!!'
    end
  end

  desc 'cadastra as moedas'
  task add_coins: :environment do
    show_spinner('Cadastrado as Moedas...') do
      coins = [
        {
          description: 'Bitcon',
          acronym: 'BTC',
          url_image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/ETHEREUM-YOUTUBE-PROFILE-PIC.png/600px-ETHEREUM-YOUTUBE-PROFILE-PIC.png',
          mining_type: MiningType.first
        },
        {
          description: 'Ethereum',
          acronym: 'ETH',
          url_image: 'https://logospng.org/download/bitcoin/logo-bitcoin-2048.png',
          mining_type: MiningType.all.sample
        },
        {
          description: 'DASH',
          acronym: 'DASH',
          url_image: 'https://s2.coinmarketcap.com/static/img/coins/200x200/131.png',
          mining_type: MiningType.all.sample
        }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc 'Castrado dos tipos de moedas'
  task add_mining_type: :environment do
    show_spinner('Cadastrando tipos de moedas...') do
      mining_types = [
        { description: 'Proof of Work', acronym: 'PoW' },
        { description: 'Proof of Stack', acronym: 'PoS' },
        { description: 'Proof of Capacity', acronym: 'PoC' }
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private

  def show_spinner(msg_start, msg_end = 'Concluido!!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :pulse_2)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
