import unittest

from .main import extract_metadata, providers_for, rewrite_body


class RewriteTests(unittest.TestCase):
    def test_plain_atuin_without_release_notes(self):
        body = (
            "| ghcr.io/atuinsh/atuin | minor | `18.21.0` → `18.22.0` |\n"
            "\n---\n\n### Configuration\n\nKeep this configuration.\n"
        )
        dep = extract_metadata(body)[0]
        self.assertEqual(dep["packageName"], "atuinsh/atuin")
        self.assertEqual(dep["newVersion"], "18.22.0")
        self.assertEqual(len(providers_for([dep])), 1)
        result = rewrite_body(body, dep, "- New feature")
        self.assertIn("### v18.22.0 changelog\n\n- New feature", result)
        self.assertTrue(result.endswith("### Configuration\n\nKeep this configuration.\n"))
        self.assertEqual(rewrite_body(result, dep, "- New feature"), result)
        updated = rewrite_body(result, dep, "- Updated feature")
        self.assertNotIn("- New feature", updated)
        self.assertEqual(updated.count("<details>"), 1)

    def test_linked_package_preserves_other_release_notes(self):
        body = (
            "| [cloudflared](https://redirect.github.com/cloudflare/cloudflared) | minor | `1` → `2` |\n"
            "### Release Notes\n\n"
            "<details>\n<summary>other/project</summary>\nOther notes\n</details>\n"
            "<details>\n<summary>cloudflare/cloudflared</summary>\n"
            "[Compare Source](https://github.com/cloudflare/cloudflared/compare/1...2)\n"
            "Old notes\n</details>\n"
        )
        result = rewrite_body(body, extract_metadata(body)[0], "New notes")
        self.assertIn("Other notes", result)
        self.assertNotIn("Old notes", result)
        self.assertIn("[Compare Source]", result)
        self.assertEqual(result.count("<details>"), 2)

    def test_unknown_plain_image_is_ignored(self):
        self.assertEqual(extract_metadata("| ghcr.io/other/image | minor | `1` → `2` |"), [])


if __name__ == "__main__":
    unittest.main()
