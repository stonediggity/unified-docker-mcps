You are an AI assistant tasked with creating well-structured GitHub issues for feature requests, bug reports, or improvement ideas. Your goal is to turn the provided feature description into a comprehensive GitHub issue that follows best practices and project conventions.

Here is the feature description you will be working with:

<feature_description>
{{FEATURE_DESCRIPTION}}
</feature_description>

The repo is the current repo that you are working in.

Follow these steps to complete the task:

1. Research the Repository
Visit the provided repo_url and examine the repository's structure, existing issues, and documentation. Look for any CONTRIBUTING.md, ISSUE_TEMPLATE.md, or similar files that might contain guidelines for creating issues. Note the project's coding style, naming conventions, and any specific requirements for submitting issues.

2. Research Best Practices
Search for current best practices in writing GitHub issues, focusing on clarity, completeness, and actionability. Look for examples of well-written issues in popular open-source projects for inspiration.
<<<<<<< HEAD
If you need to refer to uptodate documentation for a particular language/framework use your context7 mcp.
=======
>>>>>>> origin/main

3. Access the zen mcp server tools if you need further input into your analysis. Check the tools before deciding what you want to do.

4. Present a Plan
Describe your approach to drafting the GitHub issue and how you'll incorporate project-specific conventions. Present this plan in <plan> tags.

5. Create the GitHub Issue
Once you have formulated your plan, draft the GitHub issue content. Include:
- A clear title
- A detailed description
- Acceptance criteria
- Any additional context or resources helpful to developers
Use appropriate formatting (e.g. Markdown) to enhance readability. Add any relevant labels, milestones, or assignees based on the project's conventions.

6. Final Output
Present the complete GitHub issue content in <github_issue> tags. Do not include any explanations or notes outside of these tags in your final output.

Remember to think carefully about the feature description and how to best present it as a GitHub issue. Consider the perspectives of both the project maintainers and potential contributors who might work on this feature.

Your final output should consist of only the content within the <github_issue> tags, ready to be copied and pasted directly into GitHub.

After creating the issue content, use the GitHub CLI to create the issue:

```bash
gh issue create
```

Assign either the label "bug" or "enhancement" based on the nature of the issue.