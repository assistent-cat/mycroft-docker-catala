SKILLS_DIR=${SKILLS_DIR:-"/opt/mycroft/skills"}

if [[ ! -f "$SKILLS_DIR/.initiated" ]]; then

    msm install https://github.com/JarbasSkills/skill-wolfie
    msm install https://github.com/assistent-cat/skill-contes
    
    touch "$SKILLS_DIR/.initiated"
fi