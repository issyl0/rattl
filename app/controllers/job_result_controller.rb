class JobResultController < ApplicationController
  def verdict
    # Get the SOC code for the particular job.
    soc_result = JSON.parse(RestClient.get("http://api.lmiforall.org.uk/api/v1/soc/search?q=#{$job_name.gsub(" ", "+")}"))
    
    if soc_result[0]
      # Convert the UK SOC code to its US ONET code.
      onet_result = JSON.parse(RestClient.get("http://api.lmiforall.org.uk/api/v1/o-net/soc2onet/#{soc_result[0]['soc']}"))['onetCodes'][0]['code']
    
      # Search the skills endpoint for the ONET code.
      preprocesed_onet_skills = JSON.parse(RestClient.get("http://api.lmiforall.org.uk/api/v1/o-net/skills/#{onet_result}"))['scales'][0]['skills']
      # Push the ONET skills data into a hash for later processing.
      onet_skills = Hash.new
      preprocesed_onet_skills.each do |os|
        onet_skills[:name] = os['name']
        onet_skills[:value] = os['value']
      end
      # Search the abilities endpoint for the ONET code.
      preprocessed_onet_abilities = JSON.parse(RestClient.get("http://api.lmiforall.org.uk/api/v1/o-net/abilities/#{onet_result}"))['scales'][0]['abilities']
      # Push the ONET abilities data into a hash for later processing.
      onet_abilities = Hash.new
      preprocessed_onet_abilities.each do |oa|
        onet_abilities[:name] = oa['name']
        onet_abilities[:value] = oa['value']
      end

      # Push the skills thesaurus results into an array.
      skill_thesaurus_results = Array.new
      onet_skills.each do |skill|
        # The BigHugeThesaurus API doesn't handle querying for
        # multiple words, so only use the first word.
        skills_thesaurus = Dinosaurus.lookup("#{skill.last.to_s.strip.split(/\s+/)[0]}")
        skills_thesaurus.synonyms.each do |synonym|
          skill_thesaurus_results.push(synonym)
        end
        skills_thesaurus.related_terms.each do |related_term|
          skill_thesaurus_results.push(related_term)
        end
      end

      # Push the abilities thesaurus results into an array.
      ability_thesaurus_results = Array.new
      onet_abilities.each do |ability|
        # The BigHugeThesaurus API doesn't handle querying for
        # multiple words, so only use the first word.
        abilities_thesaurus = Dinosaurus.lookup("#{ability.last.to_s.strip.split(/\s+/)[0]}")
        abilities_thesaurus.synonyms.each do |synonym|
          ability_thesaurus_results.push(synonym)
        end
        abilities_thesaurus.related_terms.each do |related_term|
          ability_thesaurus_results.push(related_term)
        end
      end

      # Match the user's experience to the job's requirements.
      @match_counter = 0
      User.find(current_user.id).skills.each do |possible_match|
        if skill_thesaurus_results.include?(possible_match.name) || ability_thesaurus_results.include?(possible_match.name)
          @match_counter += 1
        end
      end

      # If the user has >= 5 skills matched, award him or her the job.
      if @match_counter >= 5
        job_pay_average(soc_result[0]['soc'])
        render :success
      else
        render :failure
      end
    else
      redirect_to job_search_path, alert: "Sorry, we couldn't find any data for that job."
    end
  end

  def job_pay_average(soc)
    avg = JSON.parse(RestClient.get("http://api.lmiforall.org.uk/api/v1/ashe/estimatePay?soc=#{soc}"))
    @avg_pay = avg['series'][0]['estpay']
  end

  def success
  end
  
  def failure
  end
end
