import os
import json
import sys
from langchain.llms import OpenAI
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate

# Define a prompt template for problem-solving
SOLUTION_TEMPLATE = """
Based on the following GitHub issue, suggest a concise and practical solution. The solution should be clear and actionable, utilizing the fewest steps possible:
Title: {issue_title}
Description: {issue_body}
Suggested Solution:
"""

def create_and_run_chain(api_key, template, issue_data):
    llm = OpenAI(api_key=api_key)
    prompt_template = PromptTemplate.from_template(template)
    chain = LLMChain(llm=llm, prompt=prompt_template)
    return chain.invoke(issue_data)["text"]

def suggest_solution(issue_file, api_key):
    with open(issue_file, 'r') as file:
        issue_data = json.load(file)

    # Prepare input data
    input_data = {
        'issue_title': issue_data['title'],
        'issue_body': issue_data['body']
    }

    # Generate solution
    solution = create_and_run_chain(api_key, SOLUTION_TEMPLATE, input_data)

    # Post Solution as Comment
    comment = {"body": solution}
    with open("comment.json", "w") as f:
        json.dump(comment, f)

    # Use GitHub CLI to post the comment
    os.system(f"gh issue comment {issue_data['number']} --json -F comment.json")

if __name__ == "__main__":
    issue_file = sys.argv[1]
    api_key = os.environ.get('OPENAI_API_KEY')
    suggest_solution(issue_file, api_key)

