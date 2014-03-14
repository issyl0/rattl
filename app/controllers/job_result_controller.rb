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

      # If the user has > 5 skills matched, award him or her the job.
    else
      redirect_to job_search_path # Need to add an error message.
    end
  end
end
