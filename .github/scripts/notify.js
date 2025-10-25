module.exports = async ({ github, context, status, environment, command }) => {
    const success = status === "success";
    const emoji = success ? "✨" : "❌";
    const message = success
        ? `${emoji} Migração concluída com sucesso!\n
           **Ambiente:** \`${environment}\`\n
           **Comando:** \`${command}\`\n
           **Data:** ${new Date().toISOString()}`
        : `${emoji} Falha na Migração!\n
           **Ambiente:** \`${environment}\`\n
           **Comando:** \`${command}\`\n
           **Data:** ${new Date().toISOString()}\n
           **Log:** [Ver Detalhes](${process.env.GITHUB_SERVER_URL}/${context.repo.owner}/${context.repo.name}/actions/runs/${context.runId})`;

    if (!success) {
        await github.rest.issues.create({
            owner: context.repo.owner,
            repo: context.repo.name,
            title: `${emoji} Falha na Migração - ${environment}`,
            body: message,
            labels: ['database', 'error', environment]
        });
    }
};
