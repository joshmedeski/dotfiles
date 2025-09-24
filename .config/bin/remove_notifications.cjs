// https://gist.github.com/eseiler/d3a6f978ceea1853f0c558879cf859c1
// Source: https://github.com/orgs/community/discussions/6874#discussioncomment-14481926
// Adapted console output (console.log and console.error)

const { exec } = require("node:child_process");
const { basename } = require("node:path");

function runShellCommand(command) {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject({ error, stderr });
        return;
      }
      resolve(stdout);
    });
  });
}

let _githubToken = null;
async function getGithubToken() {
  if (!_githubToken) {
    _githubToken = await runShellCommand("gh auth token");
  }
  return _githubToken;
}

async function getNotifications(since) {
  const response = await fetch(
    `https://api.github.com/notifications?all=true&since=${since}`,
    {
      headers: {
        Accept: "application/vnd.github+json",
        Authorization: `Bearer ${await getGithubToken()}`,
        "X-GitHub-Api-Version": "2022-11-28",
      },
    },
  );
  console.log("Response status:", response.status);
  return response.json();
}

async function shouldIncludeNotificationForRemoval(notification) {
  try {
    const response = await fetch(
      `https://api.github.com/repos/${notification.repository.full_name}`,
      {
        headers: {
          Accept: "application/vnd.github+json",
          Authorization: `Bearer ${await getGithubToken()}`,
          "X-GitHub-Api-Version": "2022-11-28",
        },
      },
    );
    console.log(" full_name:", notification.repository.full_name);
    console.log("Repo check response status:", response.status);
    return response.status === 404;
  } catch (error) {
    console.log("threw");
    if (error.code && error.code === 404) {
      return true;
    }
    console.error(error);
    throw error;
  }
}

async function markNotificationRead(notification) {
  const response = await fetch(notification.url, {
    method: "PATCH",
    headers: {
      Authorization: `Bearer ${await getGithubToken()}`,
      Accept: "application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28",
    },
  });
  if (!response.ok) {
    console.error(
      `    Failed to mark notification with thread URL ${notification.url} from repo ${notification.repository.full_name} as read: ${response.status} ${response.statusText}`,
    );
  }
}
async function markNotificationDone(notification) {
  const response = await fetch(notification.url, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${await getGithubToken()}`,
      Accept: "application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28",
    },
  });
  if (!response.ok) {
    console.error(
      `    Failed to mark notification with thread URL ${notification.url} from repo ${notification.repository.full_name} as done: ${response.status} ${response.statusText}`,
    );
  }
}

async function unsubscribe(notification) {
  const response = await fetch(notification.subscription_url, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${await getGithubToken()}`,
      Accept: "application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28",
    },
  });
  if (!response.ok) {
    console.error(
      `    Failed to unsubscribe from notification with thread URL ${notification.url} from repo ${notification.repository.full_name}: ${response.status} ${response.statusText}`,
    );
  }
}

async function main() {
  const since = process.argv[2];
  if (!since) {
    console.error(
      `    Usage: ${basename(process.argv[0])} ${basename(process.argv[1])} <since>`,
    );
    process.exit(1);
  }

  try {
    new Date(since);
  } catch (error) {
    console.error(
      `    ${since} is not a valid ISO 8601 date. Must be formatted as YYYY-MM-DDTHH:MM:SSZ.`,
    );
    console.error(
      `    Usage: ${basename(process.argv[0])} ${basename(process.argv[1])} <since>`,
    );
    process.exit(1);
  }

  const notifications = await getNotifications(since);
  for (const notification of notifications) {
    if (await shouldIncludeNotificationForRemoval(notification)) {
      console.log(
        `  Processing repository "${notification.repository.full_name}" (${notification.url})`,
      );
      console.log(`   Marking notification read`);
      await markNotificationRead(notification);
      console.log(`   Marking notification done`);
      await markNotificationDone(notification);
      console.log(`   Unsubscribing from repo`);
      await unsubscribe(notification);
    }
  }
  console.log("Done");
}

main().catch(console.error);
