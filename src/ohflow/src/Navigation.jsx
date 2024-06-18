import { useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { createStyles, Navbar, Group, Code } from "@mantine/core";
import {
  IconSwitchHorizontal,
  IconLogout,
  IconArrowsShuffle,
  IconList,
  IconCategory2,
  IconBooks,
  IconBug,
  IconSitemap,
  IconArrowMoveRight,
  IconBackhoe,
} from "@tabler/icons";

import { ImageIcon } from '@mantine/core';

const useStyles = createStyles((theme, _params, getRef) => {
  const icon = getRef("icon");
  return {
    header: {
      paddingBottom: theme.spacing.md,
      marginBottom: theme.spacing.md * 1.5,
      borderBottom: `1px solid ${
        theme.colorScheme === "dark"
          ? theme.colors.dark[4]
          : theme.colors.gray[2]
      }`,
    },

    footer: {
      paddingTop: theme.spacing.md,
      marginTop: theme.spacing.md,
      borderTop: `1px solid ${
        theme.colorScheme === "dark"
          ? theme.colors.dark[4]
          : theme.colors.gray[2]
      }`,
    },

    link: {
      ...theme.fn.focusStyles(),
      display: "flex",
      alignItems: "center",
      textDecoration: "none",
      fontSize: theme.fontSizes.sm,
      color:
        theme.colorScheme === "dark"
          ? theme.colors.dark[1]
          : theme.colors.gray[7],
      padding: `${theme.spacing.xs}px ${theme.spacing.sm}px`,
      borderRadius: theme.radius.sm,
      fontWeight: 500,

      "&:hover": {
        backgroundColor:
          theme.colorScheme === "dark"
            ? theme.colors.dark[6]
            : theme.colors.gray[0],
        color: theme.colorScheme === "dark" ? theme.white : theme.black,

        [`& .${icon}`]: {
          color: theme.colorScheme === "dark" ? theme.white : theme.black,
        },
      },
    },

    linkIcon: {
      ref: icon,
      color:
        theme.colorScheme === "dark"
          ? theme.colors.dark[2]
          : theme.colors.gray[6],
      marginRight: theme.spacing.sm,
    },

    linkActive: {
      "&, &:hover": {
        backgroundColor: theme.fn.variant({
          variant: "light",
          color: theme.primaryColor,
        }).background,
        color: theme.fn.variant({ variant: "light", color: theme.primaryColor })
          .color,
        [`& .${icon}`]: {
          color: theme.fn.variant({
            variant: "light",
            color: theme.primaryColor,
          }).color,
        },
      },
    },
  };
});

const data = [
  { link: "#/Collections", label: "Collections", icon: IconBackhoe },
  { link: "#/Workflows", label: "Workflows", icon: IconSitemap },
  { link: "#/Triggers", label: "Workflow Triggers", icon: IconArrowMoveRight },
  { link: "#/WorkflowTemplates", label: "Workflow Templates", icon: IconBooks },
  { link: "#/NodeLibrary", label: "Node Library", icon: IconCategory2 },
  { link: "#/Logs", label: "Logs", icon: IconList },
  { link: "#/Debug", label: "Debug", icon: IconBug },
];

export default function NavbarSimple({ active, onChange }) {
  const { classes, cx } = useStyles();
  const navigation = useNavigate();
  const links = data.map((item) => (
    <a
      className={cx(classes.link, {
        [classes.linkActive]: item.label === active,
      })}
      href={item.link}
      key={item.label}
      onClick={(event) => {
        event.preventDefault();
        onChange(item.label);
        navigation(item.link.substring(1));
      }}
    >
      <item.icon className={classes.linkIcon} stroke={1.5} />
      <span>{item.label}</span>
    </a>
  ));

  return (
    <Navbar style={{ width: 240 }} width={{ sm: 240 }} p="sm">
      <Navbar.Section grow>
        <Group className={classes.header} position="apart">
          <IconArrowsShuffle />
          LangFlow
          <Code sx={{ fontWeight: 700 }}>v2.1.3</Code>
        </Group>
        {links}
      </Navbar.Section>

      <Navbar.Section className={classes.footer}>
        <a
          href="#account"
          className={classes.link}
          onClick={(event) => event.preventDefault()}
        >
          <IconSwitchHorizontal className={classes.linkIcon} stroke={1.5} />
          <span>Change account</span>
        </a>

        <a
          href="#logout"
          className={classes.link}
          onClick={(event) => event.preventDefault()}
        >
          <IconLogout className={classes.linkIcon} stroke={1.5} />
          <span>Logout</span>
        </a>
      </Navbar.Section>
    </Navbar>
  );
}
